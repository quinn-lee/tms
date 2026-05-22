class OrderRoutesController < ApplicationController
  before_action :auth_staff
  
  def index
    @all_routes = OrderRoute.all
    @pagy, @routes = pagy(:offset, @all_routes.order("id desc"))
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
        flash[:error] = e.message
        redirect_to route_plan_transport_order_path(@order)
      end
    end
  end
end
