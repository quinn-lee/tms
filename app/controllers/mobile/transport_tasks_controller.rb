class Mobile::TransportTasksController < ApplicationController
	before_action :auth_driver
	def index
		@trucks = Truck.where("driver_ids @> ?", [current_user.id].to_json)
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
			@routes = OrderRoute.where(id: TaskOrderRelation.where(task_id: @task.id).map(&:order_route_id))
		end
	end

	def start
		@task = TransportTask.find(params[:id])
		if TransportTask.where(status: "in_progress").where("driver_ids @> ?", [current_user.id].to_json).count > 0
			flash[:error] = "You have unfinished tasks, Can't start/join new task"
			redirect_to mobile_transport_tasks_path and return
		end
		@task.driver_ids << current_user.id
		@task.driver_ids.uniq!
		@task.status = "in_progress"
		@task.save!
		flash[:success] = "Start Successful"
		redirect_to in_progress_orders_mobile_transport_tasks_path
	end

	def finish
		@task = TransportTask.find(params[:id])
		@routes = OrderRoute.where(id: TaskOrderRelation.where(task_id: @task.id).map(&:order_route_id))
		if @routes.where.not(status: ['finished', 'rearranged']).count > 0
			flash[:error] = "This task have unfinished order, Can't finish"
			redirect_to mobile_transport_tasks_path and return
		end
		@task.status = "finished"
		@task.save!
		flash[:success] = "Finish Successful"
		redirect_to mobile_transport_tasks_path
	end
end