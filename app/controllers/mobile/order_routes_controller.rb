class Mobile::OrderRoutesController < ApplicationController
	before_action :auth_driver

	def picked
		ActiveRecord::Base.transaction do
      begin
				@route = OrderRoute.find(params[:id])
				@tor = TaskOrderRelation.find_by(task_id: params[:task_id], order_route_id: @route.id)
				@tor.status = "picked"
				@tor.actual_pickup_time = Time.now
				@tor.save!
				if @route.order.order_status == "processing"
					@route.order.update!(order_status: "picked")
				end
				seq = TrackingInfo.where(order_id: @route.order_id).count + 1
				ti = TrackingInfo.new(params.require(:tracking_info).permit(images: []))
				ti.order_id = @route.order_id
				ti.location = @route.first_location
				ti.event = "pickup"
				ti.description = "Cargo Picked Successful, Waiting for Loading."
				ti.event_time = Time.now
				ti.driver_id = current_user.id
				ti.seq = seq
				ti.save!
				flash[:success] = "Picked Successful"
				redirect_to in_progress_orders_mobile_transport_tasks_path
			rescue => e
				flash[:error] = e.message
				redirect_to in_progress_orders_mobile_transport_tasks_path
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end

	def loaded
		ActiveRecord::Base.transaction do
      begin
				@route = OrderRoute.find(params[:id])
				@tor = TaskOrderRelation.find_by(task_id: params[:task_id], order_route_id: @route.id)
				@tor.status = "loaded"
				@tor.actual_loaded_time = Time.now
				@tor.save!
				seq = TrackingInfo.where(order_id: @route.order_id).count + 1
				ti = TrackingInfo.new(params.require(:tracking_info).permit(:loading_scan))
				ti.order_id = @route.order_id
				ti.location = @route.first_location
				ti.event = "load"
				ti.description = "Cargo Loaded Successful, Waiting for Sending To #{@route.end_location}."
				ti.event_time = Time.now
				ti.driver_id = current_user.id
				ti.seq = seq
				ti.save!
				flash[:success] = "Loaded Successful"
				redirect_to in_progress_orders_mobile_transport_tasks_path
			rescue => e
				flash[:error] = e.message
				redirect_to in_progress_orders_mobile_transport_tasks_path
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end

	def sent
		ActiveRecord::Base.transaction do
      begin
				@route = OrderRoute.find(params[:id])
				@tor = TaskOrderRelation.find_by(task_id: params[:task_id], order_route_id: @route.id)
				@tor.status = "sent"
				@tor.actual_delivery_time = Time.now
				@tor.save!
				next_route = OrderRoute.find_by(order_id: @route.order_id, node_order: (@route.node_order + 1))
				seq = TrackingInfo.where(order_id: @route.order_id).count + 1
				ti = TrackingInfo.new(params.require(:tracking_info).permit(images: []))
				ti.order_id = @route.order_id
				ti.location = @route.end_location
				ti.event = "send"
				if next_route.present?
					ti.description = "Cargo Sent Successful, Next Destination-#{next_route.end_location}"
				else
					ti.description = "Cargo Sent Successful"
					@route.order.update!(order_status: "sent")
					if @route.order.is_return?
						parent = TransportOrder.find(@route.order.parent_id)
						parent.update!(order_status: "returned")
					end
				end
				ti.event_time = Time.now
				ti.driver_id = current_user.id
				ti.seq = seq
				ti.save!
				flash[:success] = "Sent Successful"
				redirect_to in_progress_orders_mobile_transport_tasks_path
			rescue => e
				flash[:error] = e.message
				redirect_to in_progress_orders_mobile_transport_tasks_path
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end

	def rearranged
		ActiveRecord::Base.transaction do
      begin
				@route = OrderRoute.find(params[:id])
				@tor = TaskOrderRelation.find_by(task_id: params[:task_id], order_route_id: @route.id)
				seq = TrackingInfo.where(order_id: @route.order_id).count + 1
				ti = TrackingInfo.new(
					order_id: @route.order_id,
					location: {"pickup"=>@route.first_location, "sent"=>@route.end_location}[params[:from]],
					event: params[:from],
					description: {"pickup"=>"PickUp Failed", "sent"=>"Sent Failed"}[params[:from]],
					event_time: Time.now,
					driver_id: current_user.id,
					seq: seq
					)
				ti.save!
				# 该任务相同订单的路线都要rearrange
				OrderRoute.where(id: TaskOrderRelation.where(task_id: params[:task_id], order_id: @route.order_id).map(&:order_route_id)).each do |route|
					route.status = "rearranged"
					route.save!
				end
				TaskOrderRelation.where(task_id: params[:task_id], order_id: @route.order_id).each do |tor|
					tor.status = "finished"
					tor.save!
				end
				flash[:success] = "#{{"pickup"=>"PickUp Failed", "sent"=>"Sent Failed"}[params[:from]]}, Rearranged Successful"
				redirect_to in_progress_orders_mobile_transport_tasks_path
			rescue => e
				flash[:error] = e.message
				redirect_to in_progress_orders_mobile_transport_tasks_path
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end

	def finished
		ActiveRecord::Base.transaction do
      begin
				@route = OrderRoute.find(params[:id])
				@tor = TaskOrderRelation.find_by(task_id: params[:task_id], order_route_id: @route.id)
				@tor.status = "finished"
				@tor.save!
				flash[:success] = "Finished Successful"
				redirect_to in_progress_orders_mobile_transport_tasks_path
			rescue => e
				flash[:error] = e.message
				redirect_to in_progress_orders_mobile_transport_tasks_path
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end
end