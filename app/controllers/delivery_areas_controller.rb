class DeliveryAreasController < ApplicationController
  before_action :auth_staff
  
  def index
    @all_areas = DeliveryArea.all
    @pagy, @areas = pagy(:offset, @all_areas.order("id desc"))
  end

	def new
		@area = DeliveryArea.new
	end

	def create
		@area = DeliveryArea.new(params.require(:delivery_area)
      .permit(:area_code, :area_name, :dispatch_frequency, :min_order_num, 
        :truck_max_volume, :truck_max_weight_t, :branch_id, :postcodes))
    ActiveRecord::Base.transaction do
      begin
        @area.status = "normal"
        @area.save!
        @area.postcodes.split(",").each do |postcode|
          DeliveryAreaPostcode.create!(area_id: @area.id, post_code: postcode)
        end
        flash[:success] = "Delivery Area Created Successful"
        redirect_to delivery_areas_path
      rescue => e
        logger.info e.backtrace
        render :new, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end

  def edit
    @area = DeliveryArea.find(params[:id])
  end

  def update
    @area = DeliveryArea.find(params[:id])
    ActiveRecord::Base.transaction do
      begin
        @area.update!(params.require(:delivery_area)
          .permit(:area_code, :area_name, :dispatch_frequency, :min_order_num, 
        :truck_max_volume, :truck_max_weight_t, :branch_id, :postcodes, :status))
        DeliveryAreaPostcode.where(area_id: @area.id).delete_all
        @area.postcodes.split(",").each do |postcode|
          DeliveryAreaPostcode.create!(area_id: @area.id, post_code: postcode)
        end
        flash[:success] = "Delivery Area Updated Successful"
        redirect_to delivery_areas_path
      rescue => e
        logger.info e.backtrace
        render :edit, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
  end
end
