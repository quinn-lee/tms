class TransportOrder < ApplicationRecord

  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  has_many :order_routes, :class_name => 'OrderRoute', :dependent => :destroy, :foreign_key => :order_id
	
  validates_presence_of :goods_name, :goods_type, :goods_weight, :goods_volume, \
    :goods_quantity

  validates_presence_of :consignee_city, :consignee_street, :consignee_postcode, \
    :consignee_name, :consignee_phone, unless: :is_return?

  validates_presence_of :appointment_time, :shipper_name, :shipper_phone, :shipper_city, :shipper_street, \
    :shipper_postcode, if: :need_pickup?
  validates_presence_of :branch_id, if: :need_branch?


	before_validation :setup, :on => :create

  def from_show
    if need_pickup
      "#{shipper_city},#{shipper_street}#{shipper_streetnum} #{shipper_housenum}/#{shipper_postcode}"
    else
      branch_code
    end
  end

  def to_show
    "#{consignee_city},#{consignee_street}#{consignee_streetnum} #{consignee_housenum}/#{consignee_postcode}"
  end

  def branch_code
    branch_id.present? ? Branch.find_by(id: branch_id)&.branch_code : ""
  end

  def need_pickup?
    need_pickup
  end

  def is_return?
    is_return
  end

  def need_branch?
    !need_pickup || is_return
  end

  def can_plan?
    (order_status == "pending" || order_status == "planning") && (need_pickup || (!need_pickup && arrival_time.present?))
  end

  def estimated_pickup_time
    if need_pickup
      order_routes.find_by(node_order: 1)&.expected_arrival_time
    end
  end

  def pickup_drivers
    if need_pickup
      if route = order_routes.find_by(node_order: 1)
        if tor = TaskOrderRelation.find_by(order_route_id: route.id)
          if tt = TransportTask.find_by(id: tor.task_id)
            User.where(id: tt.driver_ids)
          else
            []
          end
        else
          []
        end
      else
        []
      end
    else
      []
    end
  end

  def parent
    parent_id.present? ? TransportOrder.find_by(id: parent_id) : nil
  end

	private
	def setup
    self.order_no ||= gen_order_no
    self.order_status ||= "pending"
    self.order_amount ||= 0
  end

  def gen_order_no
    seq = ActiveRecord::Base.connection.execute("select nextval('orders_seq')")[0]['nextval']
    "TO#{Time.now.strftime('%y%m%d')}#{sprintf('%06d', seq)}"
  end
end
