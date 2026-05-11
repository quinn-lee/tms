class TransportOrdersController < ApplicationController

  def index
    @all_orders = TransportOrder.where(user_id: current_user.id)
    @pagy, @orders = pagy(:offset, @all_orders.order("id desc"))
  end

  def show
    @order = TransportOrder.find(params[:id])
  end

	def new
		@order = TransportOrder.new
	end

	def create
		@order = TransportOrder.new(params.require(:transport_order)
      .permit(:goods_name, :goods_type, :goods_quantity, :is_high_value, 
        :goods_weight, :goods_volume, :shipper_name, :shipper_phone, 
        :start_address, :start_latitude, :start_longitude, :consignee_name,
        :consignee_phone, :end_address, :end_latitude, :end_longitude,
        :need_pickup, :appointment_time, :remark))
		@order.user_id = current_user.id
		ActiveRecord::Base.transaction do
      begin
        @order.save!
        flash[:success] = "Created Successful"
        redirect_to transport_orders_path
      rescue => e
        render :new, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end
end
