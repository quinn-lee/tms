class TransportTasksController < ApplicationController
	before_action :auth_staff
	
	def index
		@all_tasks = TransportTask.all
    @pagy, @tasks = pagy(:offset, @all_tasks.order("id desc"))
	end

	def new
		begin
			@ids = Cart.where(user_id: current_user.id).map(&:route_id)
			raise "Please Select Routes to Create Tasks" if @ids.blank?
			@routes = OrderRoute.where(id: @ids)
			@task = TransportTask.new
		rescue=>e
			logger.info e.backtrace
			flash[:error] = e.message
			redirect_to order_routes_path
		end
	end

	def create
		@ids = Cart.where(user_id: current_user.id).map(&:route_id)
		if @ids.blank?
      flash[:error] = "Please Select Routes to Create Tasks"
      redirect_to order_routes_path and return
    end
		
    ActiveRecord::Base.transaction do
      begin
      	@ids.each do |route_id| 
	      	route = OrderRoute.find(route_id)
	      	if route.status!="init" && route.status!="rearranged"
	      		raise "Can't arrange this route, status=#{route.status}"
	      	end
	      end
      	params.require(:transport_task).permit(truck_id: [])["truck_id"].each do |truck_id|
      		if truck_id.present?
	      		@task = TransportTask.new(params.require(:transport_task).permit(:task_date))
	      		@task.truck_id = truck_id
			      @task.order_quantity = @ids.count
		        @task.save!
			      @ids.each do |route_id| 
			      	route = OrderRoute.find(route_id)
			      	@tor = TaskOrderRelation.new(
			      		task_id: @task.id,
			      		order_route_id: route.id,
			      		order_id: route.order_id,
			      		status: "init"
			      		)
			      	@tor.save!
			      	route.status="scheduled"
			      	route.save!
			      end
			    end
		    end
		    Cart.where(user_id: current_user.id).delete_all
        flash[:success] = "Task Created Successful"
        redirect_to transport_tasks_path
      rescue => e
      	logger.info e.backtrace
      	@msg = e.message
        render :new, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end

	def set_truck
		@task = TransportTask.find(params[:id])
	end

	def seted_truck
		ActiveRecord::Base.transaction do
      begin
				@task = TransportTask.find(params[:id])
				@task.truck_id = params[:truck_id]
				@task.task_date = params[:task_date]
				@task.save!
				begin
					@task.sort_orders
				rescue=>e
					logger.info e.backtrace
					OrderRoute.where(id: TaskOrderRelation.where(task_id: @task.id).map(&:order_route_id)).order("id asc").each_with_index do |route, indx|
						route.update!(task_order: indx)
					end
				end
				flash[:success] = "Task Assign Truck Successful"
        redirect_to transport_tasks_path
			rescue => e
      	logger.info e.backtrace
      	@msg = e.message
        render :set_truck, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end
end
