class TransportTasksController < ApplicationController
	before_action :auth_staff
	
	def index
		@all_tasks = TransportTask.all
    @pagy, @tasks = pagy(:offset, @all_tasks.order("id desc"))
	end

	def new
		begin
			raise "Please Select Routes to Create Tasks" if params[:ids].blank?
			@ids = []
			params[:ids].each do |ids|
				if ids.include? ",,,"
					ids.split(",,,").each do |sid|
						@ids << sid
					end
				else
					@ids << ids
				end
			end
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
			      		status: "init"
			      		)
			      	@tor.save!
			      	route.status="scheduled"
			      	route.save!
			      end
			    end
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
