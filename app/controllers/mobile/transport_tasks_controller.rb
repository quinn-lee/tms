class Mobile::TransportTasksController < ApplicationController
	before_action :auth_driver
	def index
		@trucks = Truck.where("driver_ids @> ?", [current_user.id].to_json).where(truck_status: "operation")
    @pending_tasks = []
    @processing_tasks = []
    @trucks.each do |truck|
      truck.tasks.where(status: ["pending","in_progress"]).each do |task|
      	if task.driver_ids.include? current_user.id
      		@processing_tasks << task
      	else
        	@pending_tasks << task
        end
      end
    end
	end

	def show
		@task = TransportTask.find(params[:id])
		@routes = OrderRoute.where(id: TaskOrderRelation.where(task_id: @task.id).map(&:order_route_id))
	end

	def in_progress_orders
		@task = TransportTask.where(status: "in_progress").where("driver_ids @> ?", [current_user.id].to_json).first
		if @task.present?
			@routes = OrderRoute.where(id: TaskOrderRelation.where.not(status: ["rearranged","finished"]).where(task_id: @task.id).map(&:order_route_id))
		end
	end

	def start
		ActiveRecord::Base.transaction do
      begin
				@task = TransportTask.find(params[:id])
				if TransportTask.where(status: "in_progress").where("driver_ids @> ?", [current_user.id].to_json).count > 0
					flash[:error] = "You have unfinished tasks, Can't start/join new task"
					redirect_to mobile_transport_tasks_path and return
				end
				# 第一个司机开始任务
				if @task.driver_ids.blank?
					@task.driver_ids << current_user.id
					@task.driver_ids.uniq!
					@task.status = "in_progress"
					@task.truck_delivery_time = Time.now if @task.truck_delivery_time.blank?
					TaskOrderRelation.where(task_id: @task.id).each do |tor|
						tor.update!(status: "scheduled")
					end
					# 上门取货的第一条数据，自动结束
					TaskOrderRelation.where(task_id: @task.id).each do |tor|
						route = OrderRoute.find(tor.order_route_id)
						if route.node_order == 1 && route.order.need_pickup
							tor.update!(status: "finished")
						end
					end

					# 存在前续未完成的任务，不能开始
					TaskOrderRelation.where(task_id: @task.id).each do |tor|
						route = OrderRoute.find(tor.order_route_id)
						if pre_route = OrderRoute.find_by(order_id: route, node_order: (route.node_order-1))
							if pre_route.status != "scheduled"
								raise "There are tasks that have not ended in the previous route. Cannot start."
							end
							if TaskOrderRelation.where(task_id: @task.id, order_route_id: pre_route.id).where.not(status: "finished").any?
								raise "There are tasks that have not ended in the previous route. Cannot start."
							end
						end
					end
				else # 后面的司机只需要加入
					@task.driver_ids << current_user.id
					@task.driver_ids.uniq!
				end
				@task.save!

				flash[:success] = "Start Successful"
				redirect_to in_progress_orders_mobile_transport_tasks_path
			rescue => e
				flash[:error] = e.message
				redirect_to mobile_transport_tasks_path
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end

	def finish
		@task = TransportTask.find(params[:id])
		@tors = TaskOrderRelation.where(task_id: @task.id)
		if @tors.where.not(status: ['finished']).count > 0
			flash[:error] = "This task have unfinished order, Can't finish"
			redirect_to mobile_transport_tasks_path and return
		end
		@task.status = "finished"
		@task.truck_recovery_time = Time.now
		@task.save!
		flash[:success] = "Finish Successful"
		redirect_to mobile_transport_tasks_path
	end

	def break_down
		ActiveRecord::Base.transaction do
      begin
				@task = TransportTask.find(params[:id])
				@task.status = "suspend"
				@task.save!
				
				TaskOrderRelation.where(task_id: @task.id).each do |tor|
					tor.update!(status: "finished")
					route = OrderRoute.find(tor.order_route_id)
					route.status = "rearranged"
					route.save!
				end
				@task.truck.update!(truck_status: "maintenance")

				TransportTask.where(status: "pending", truck_id: @task.truck_id).each do |task|
					task.status = "suspend"
					task.save!
				
					TaskOrderRelation.where(task_id: task.id).each do |tor|
						tor.update!(status: "finished")
						route = OrderRoute.find(tor.order_route_id)
						route.status = "rearranged"
						route.save!
					end
				end

				flash[:success] = "Truck Breakdown Registration Successful"
				redirect_to mobile_transport_tasks_path
			rescue => e
				flash[:error] = e.message
				redirect_to mobile_transport_tasks_path
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end
end