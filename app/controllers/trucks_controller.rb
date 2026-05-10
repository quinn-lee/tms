class TrucksController < ApplicationController
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
end
