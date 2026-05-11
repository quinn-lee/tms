class OrderRoutesController < ApplicationController
	def destroy
    @order_route = OrderRoute.find(params[:id])
    @order = @order_route.order
    @order_route.destroy
    flash[:success] = "Plan Delete Successful"
    redirect_to route_plan_transport_order_path(@order)
  end
end
