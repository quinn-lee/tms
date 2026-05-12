class TransportTasksController < ApplicationController
	before_action :auth_staff
	
	def index
		@all_tasks = TransportTask.all
    @pagy, @tasks = pagy(:offset, @all_tasks.order("id desc"))
	end

	def new
		begin
			raise "Please Select Routes to Create Tasks" if params[:ids].blank?
			@ids = params[:ids]
			@task = TransportTask.new
		rescue=>e
			flash[:error] = e.message
			redirect_to order_routes_path
		end
	end

	def create
		@ids = params[:ids]
		if @ids.blank?
      flash[:error] = "Please Select Routes to Create Tasks"
      redirect_to order_routes_path and return
    end
		@task = TransportTask.new(params.require(:transport_task)
      .permit(:truck_id, :task_date))
    ActiveRecord::Base.transaction do
      begin
	      @task.order_quantity = @ids.count
        @task.save!
	      @ids.each do |route_id| 
	      	route = OrderRoute.find(route_id)
	      	if route.status!="init" && route.status!="rearranged"
	      		raise "Can't arrange this route, status=#{route.status}"
	      	end
	      	@tor = TaskOrderRelation.new(
	      		task_id: @task.id,
	      		order_route_id: route.id,
	      		status: "init"
	      		)
	      	@tor.save!
	      	route.status="scheduled"
	      	route.save!
	      end
        flash[:success] = "Task Created Successful"
        redirect_to order_routes_path
      rescue => e
      	@msg = e.message
        render :new, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end
end
