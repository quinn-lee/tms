class TransportOrdersController < ApplicationController
  before_action :auth_customer, only: [:index, :new, :create, :returns, :new_pickup_order, :new_return, :create_return]
  before_action :auth_staff, only: [:staff_views, :route_plan, :route_planed, :arrived]

  def index
    @all_orders = TransportOrder.where(user_id: current_user.id).where(is_return: false)
    @pagy, @orders = pagy(:offset, @all_orders.order("id desc"))
  end

  def returns
    @all_orders = TransportOrder.where(user_id: current_user.id).where(is_return: true)
    @pagy, @orders = pagy(:offset, @all_orders.order("id desc"))
  end

  def staff_views
    @all_orders = TransportOrder.all
    @pagy, @orders = pagy(:offset, @all_orders.order("id desc"))
  end

  def show
    @order = TransportOrder.find(params[:id])
  end

	def new
		@order = TransportOrder.new
	end

  def new_pickup_order
    @order = TransportOrder.new
  end

  def new_return
    @parent = TransportOrder.find(params[:id])
    @order = TransportOrder.new(parent_id: @parent.id, need_pickup: true)
  end

  def create_return
    ActiveRecord::Base.transaction do
      begin
        @order = TransportOrder.new(params.require(:transport_order)
          .permit(:need_pickup, :parent_id, :appointment_time, :branch_id, :remark))
        @order.user_id = current_user.id
        @order.is_return = true
        @parent = TransportOrder.find(@order.parent_id)
        @order.shipper_city = @parent.consignee_city
        @order.shipper_street = @parent.consignee_street
        @order.shipper_streetnum = @parent.consignee_streetnum
        @order.shipper_housenum = @parent.consignee_housenum
        @order.shipper_postcode = @parent.consignee_postcode
        @order.shipper_name = @parent.consignee_name
        @order.shipper_phone = @parent.consignee_phone
        @order.goods_name = @parent.goods_name
        @order.goods_type = @parent.goods_type
        @order.is_high_value = @parent.is_high_value
        @order.goods_weight = @parent.goods_weight
        @order.goods_volume = @parent.goods_volume
        @order.goods_quantity = @parent.goods_quantity
        @order.save!

        @parent.order_status = "returning"
        @parent.save!
        flash[:success] = "Created Return Order Successful"
        redirect_to transport_orders_path
      rescue => e
        render :new_return, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
  end

	def create
		@order = TransportOrder.new(params.require(:transport_order)
      .permit(:goods_name, :goods_type, :goods_quantity, :is_high_value, 
        :goods_weight, :goods_volume, :shipper_name, :shipper_phone, 
        :shipper_city, :shipper_street, :shipper_streetnum, :shipper_housenum,
        :shipper_postcode, :consignee_city, :consignee_street, :consignee_name,
        :consignee_phone, :consignee_streetnum, :appointment_time, :remark,
        :consignee_housenum, :consignee_postcode, :need_pickup, :branch_id))
		@order.user_id = current_user.id
		ActiveRecord::Base.transaction do
      begin
        @order.save!
        flash[:success] = "Created Successful"
        redirect_to transport_orders_path
      rescue => e
        if @order.need_pickup
          render :new_pickup_order, status: :unprocessable_entity
        else
          render :new, status: :unprocessable_entity
        end
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end

  def route_plan
    begin
      @order = TransportOrder.find(params[:id])
      @last_route = @order.order_routes.order("node_order desc").first
      @order_route = OrderRoute.new(node_order: @last_route.present? ? @last_route.node_order + 1 : 1)
    rescue => e
      flash[:error] = e.message
      redirect_to staff_views_transport_orders_path
    end
  end

  def route_planed
    ActiveRecord::Base.transaction do
      begin
        @order = TransportOrder.find(params[:id])
        unless @order.can_plan?
          flash[:error] = "Route Planning Completed, Can't Plan!"
          redirect_to route_plan_transport_order_path(@order) and return
        end
        @last_route = @order.order_routes.order("node_order desc").first
        @order_route = OrderRoute.new(params.require(:order_route)
          .permit(:first_location, :end_location, :planned_mileage,
            :planned_duration, :expected_departure_time, :expected_arrival_time, 
            :remark, :node_order))
        @order_route.status = "init"
        @order_route.order_id = @order.id
        @order_route.save!
        @order.order_status = "planning"
        if @order.is_return
          if @order_route.end_location == @order.branch_code
            @order.order_status = "processing"
          end
        else
          if @order_route.end_location == @order.to_show
            @order.order_status = "processing"
          end
        end
        @order.save!
        flash[:success] = "Plan New Route Successful"
        redirect_to route_plan_transport_order_path(@order)
      rescue => e
        render :route_plan, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
  end

  def arrived
    begin
      @order = TransportOrder.find(params[:id])
      @order.update!(arrival_time: Time.now)
      flash[:success] = "Order-#{@order.order_no}'s cargo has arrived at the warehouse!"
      redirect_to staff_views_transport_orders_path
    rescue => e
      flash[:error] = e.message
      redirect_to staff_views_transport_orders_path
    end
  end
end
