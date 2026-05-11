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

  def route_plan
    begin
      @order = TransportOrder.find(params[:id])
      last_route = @order.order_routes.order("node_order desc").first
      @order_route = OrderRoute.new(first_location: last_route.present? ? last_route.end_location : @order.start_address)
    rescue => e
      flash[:error] = e.message
      redirect_to transport_orders_path
    end
  end

  def route_planed
    ActiveRecord::Base.transaction do
      begin
        @order = TransportOrder.find(params[:id])
        last_route = @order.order_routes.order("node_order desc").first
        @order_route = OrderRoute.new(params.require(:order_route)
          .permit(:first_location, :end_location, :planned_mileage,
            :planned_duration, :expected_departure_time, :expected_arrival_time, 
            :remark))
        @order_route.node_order = last_route.present? ? last_route.node_order + 1 : 1
        @order_route.status = "init"
        @order_route.order_id = @order.id
        @order_route.save!
        @order.order_status = "processing"
        @order.save!
        flash[:success] = "Plan New Route Successful"
        redirect_to route_plan_transport_order_path(@order)
      rescue => e
        render :route_plan, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
  end
end
