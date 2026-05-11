class Mobile::OrderRoutesController < ApplicationController
	def picked
		@route = OrderRoute.find(params[:id])
		@route.status = "picked"
		@route.save!
		flash[:success] = "Picked Successful"
		redirect_to in_progress_orders_mobile_transport_tasks_path
	end

	def loaded
		@route = OrderRoute.find(params[:id])
		@route.status = "loaded"
		@route.save!
		flash[:success] = "Loaded Successful"
		redirect_to in_progress_orders_mobile_transport_tasks_path
	end

	def sent
		@route = OrderRoute.find(params[:id])
		@route.status = "sent"
		@route.save!
		flash[:success] = "Sent Successful"
		redirect_to in_progress_orders_mobile_transport_tasks_path
	end

	def finished
		@route = OrderRoute.find(params[:id])
		@route.status = "finished"
		@route.save!
		flash[:success] = "Finished Successful"
		redirect_to in_progress_orders_mobile_transport_tasks_path
	end
end