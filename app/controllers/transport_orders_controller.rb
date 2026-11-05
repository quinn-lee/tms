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
    if params[:order_no].present?
      @all_orders = @all_orders.where("order_no ilike '%#{params[:order_no]}%'")
    end
    if params[:user_id].present?
      @all_orders = @all_orders.where(user_id: params[:user_id])
    end
    if params[:need_pickup].present?
      @all_orders = @all_orders.where(need_pickup: params[:need_pickup])
    end
    if params[:order_status].present?
      @all_orders = @all_orders.where(order_status: params[:order_status])
    end
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
        logger.info e.backtrace
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
        logger.info e.backtrace
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
      logger.info e.backtrace
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
        logger.info e.backtrace
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
      logger.info e.backtrace
      flash[:error] = e.message
      redirect_to staff_views_transport_orders_path
    end
  end

  def template
    send_file("public/templates/orders_upload.xlsx")
  end

  def uploaded
    ActiveRecord::Base.transaction do
      @errors = []
      begin
        raise "Warehouse Must Selected!" if params[:branch_id].blank?
        raise "Customer Must Selected!" if params[:user_id].blank?
        raise "File Not Exists!" if params[:file].blank?
        xlsx = Roo::Spreadsheet.open(params[:file])
        @orders = []
        @sheet = xlsx.sheet(0)
        raise "File Can't Be Blank!" if @sheet.last_row < 2
        (2..@sheet.last_row).each do |i|
          row = @sheet.row(i)
          if row[0].blank? or row[1].blank? or row[2].blank? or row[3].blank? or row[4].blank? or row[7].blank? or row[8].blank? or row[9].blank?
            @errors << "Line #{i}, Content is incomplete"
            next
          end
          @order = TransportOrder.new(
            goods_name: "unknown",
            goods_type: "general",
            goods_weight: row[8],
            goods_volume: row[9],
            goods_quantity: 1,
            branch_id: params[:branch_id],
            user_id: params[:user_id],
            tracking_num: row[0].is_a?(Float) ? row[0].to_i.to_s : row[0].to_s,
            consignee_name: row[1].to_s,
            consignee_phone: row[2].to_s,
            consignee_city: row[3].to_s,
            consignee_street: row[4].to_s,
            consignee_streetnum: row[5].to_s,
            consignee_housenum: row[6].to_s,
            consignee_postcode: row[7].is_a?(Float) ? row[7].to_i.to_s : row[7].to_s,
            order_status: "processing",
            need_pickup: false,
            arrival_time: Time.now
            )
          @order.save!
          @orders << @order
          # 创建route
          @order_route = OrderRoute.new(
            first_location: @order.branch_code, 
            end_location: @order.to_show, 
            node_order: 0,
            task_order: 0,
            status: "init",
            order_id: @order.id)
          @order_route.save!
        end
=begin #不自动创建任务，由仓库去分配
        # 创建任务
        DeliveryArea.where(status: "normal").each do |area|
          @task = TransportTask.create!(branch_id: params[:branch_id])
          @orders.each do |order|
            if DeliveryAreaPostcode.where(area_id: area.id, post_code: order.consignee_postcode).any?
              route = order.order_routes.first
              @tor = TaskOrderRelation.new(
                task_id: @task.id,
                order_route_id: route.id,
                order_id: order.id,
                status: "init"
                )
              @tor.save!
              route.status="scheduled"
              route.save!
            end
          end
          # 没有该区域的订单，删除该任务
          order_quantity = TaskOrderRelation.where(task_id: @task.id).count
          if order_quantity > 0
            @task.update!(order_quantity: order_quantity)
          else
            @task.destroy!
          end
        end
        # 未分配区域单独创建一个任务
        @task = TransportTask.create!(branch_id: params[:branch_id])
        @orders.each do |order|
          unless TaskOrderRelation.where(order_id: order.id).any?
            route = order.order_routes.first
            @tor = TaskOrderRelation.new(
              task_id: @task.id,
              order_route_id: route.id,
              order_id: order.id,
              status: "init"
              )
            @tor.save!
            route.status="scheduled"
            route.save!
          end
        end
        # 没有该区域的订单，删除该任务
        order_quantity = TaskOrderRelation.where(task_id: @task.id).count
        if order_quantity > 0
          @task.update!(order_quantity: order_quantity)
        else
          @task.destroy!
        end
=end
        if @errors.present?
          #render :new_batch, status: :unprocessable_entity
          raise ActiveRecord::Rollback,"rollback!"
        else
          flash[:success] = "Delivery Orders Uploaded Successful"
          redirect_to staff_views_transport_orders_path
        end
      rescue => e
        logger.info e.backtrace
        @errors << e.message if e.message != "rollback!"
        render :new_batch, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
  end
end
