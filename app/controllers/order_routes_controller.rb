class OrderRoutesController < ApplicationController
  before_action :auth_staff
  
  def index
    @all_routes = OrderRoute.where(status: ["init", "rearranged"])
    @all_routes = @all_routes.joins(:order).where("transport_orders.user_id = ?", params[:user_id]) if params[:user_id].present?
    if params[:expected_arrival_time].present?
      @all_routes = @all_routes.where("expected_arrival_time >= '#{params[:expected_arrival_time]} 00:00:00' and expected_arrival_time <= '#{params[:expected_arrival_time]} 23:59:59'")
    end
    @all_routes = @all_routes.where("last_detail->>'city' ilike '%#{params[:city]}%'") if params[:city].present?
    @all_routes = @all_routes.where("last_detail->>'postcode' ilike '%#{params[:postcode]}%'") if params[:postcode].present?
    # 上门取货的订单，创建任务时第1、2条线路需要合并在一起
    @routes = [] # 单个线路
    @c_routes = [] # 合并线路
    c_ids = []
    @all_routes.order("id asc").each do |route|
      next if c_ids.include? route.id
      if route.order.need_pickup && route.node_order == 1
        if route2 = @all_routes.find_by(order_id: route.order_id, node_order: 2)
          c_ids << route.id << route2.id
          @c_routes << [route, route2]
        else
          @routes << route
        end
      elsif route.order.need_pickup && route.node_order == 2
        if route1 = @all_routes.find_by(order_id: route.order_id, node_order: 1)
          c_ids << route.id << route1.id
          @c_routes << [route1, route]
        else
          @routes << route
        end
      else
        @routes << route
      end
    end
    #@pagy, @routes = pagy(:offset, @all_routes.order("id desc"))
  end

	def destroy
    ActiveRecord::Base.transaction do
      begin
        @order_route = OrderRoute.find(params[:id])
        @order = @order_route.order
        @order.order_status = "planning"
        @order.save!
        @order_route.destroy!
        flash[:success] = "Plan Delete Successful"
        redirect_to route_plan_transport_order_path(@order)
      rescue => e
        logger.info e.backtrace
        flash[:error] = e.message
        redirect_to route_plan_transport_order_path(@order)
      end
    end
  end
end
