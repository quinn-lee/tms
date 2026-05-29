class TrucksController < ApplicationController
  before_action :auth_staff
  
  def index
    @all_trucks = Truck.all
    @pagy, @trucks = pagy(:offset, @all_trucks.order("id desc"))
  end

	def new
		@truck = Truck.new
	end

	def create
		@truck = Truck.new(params.require(:truck)
      .permit(:truck_plate, :branch_id, :truck_type, :truck_model, :max_load, 
      	:max_volume, :gps_device_id, :gps_status, :total_mileage))
    ActiveRecord::Base.transaction do
      begin
        @truck.save!
        flash[:success] = "Truck Created Successful"
        redirect_to trucks_path
      rescue => e
        render :new, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end

  def edit
    @truck = Truck.find(params[:id])
  end

  def update
    @truck = Truck.find(params[:id])
    ActiveRecord::Base.transaction do
      begin
        @truck.update!((params.require(:truck).permit(:truck_plate, 
          :branch_id, :truck_type, :truck_model, :max_load, :max_volume, 
          :gps_device_id, :gps_status, :total_mileage, :truck_status)))
        flash[:success] = "Truck Updated Successful"
        redirect_to trucks_path
      rescue => e
        render :edit, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
  end

  def bound_drivers
    begin
      @truck = Truck.find(params[:id])
      @bound_drivers = User.where(staff_grade: "driver").where(id: @truck.driver_ids)
      @new_drivers = User.where(staff_grade: "driver").where.not(id: @truck.driver_ids)
    rescue => e
      flash[:error] = e.message
      redirect_to trucks_path
    end
  end

  def binding_driver
    ActiveRecord::Base.transaction do
      begin
        @truck = Truck.find(params[:id])
        if params[:driver_id].blank?
          raise "Please select driver!"
        end
        @truck.driver_ids = (@truck.driver_ids << params[:driver_id].to_i)
        @truck.save!
        flash[:success] = "Assign New Driver Successful"
        redirect_to bound_drivers_truck_path(@truck)
      rescue => e
        flash[:error] = e.message
        redirect_to bound_drivers_truck_path(@truck)
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
  end

  def unbind_driver
    ActiveRecord::Base.transaction do
      begin
        @truck = Truck.find(params[:id])
        if params[:driver_id].blank?
          raise "Please select driver!"
        end
        @truck.driver_ids = (@truck.driver_ids - [params[:driver_id].to_i])
        @truck.save!
        flash[:success] = "Unbind Driver Successful"
        redirect_to bound_drivers_truck_path(@truck)
      rescue => e
        flash[:error] = e.message
        redirect_to bound_drivers_truck_path(@truck)
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
  end
end
