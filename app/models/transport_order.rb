class TransportOrder < ApplicationRecord

  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  has_many :order_routes, :class_name => 'OrderRoute', :dependent => :destroy, :foreign_key => :order_id
	
  validates_presence_of :goods_name, :goods_type, :goods_weight, :goods_volume, \
    :goods_quantity, :consignee_city, :consignee_street, :consignee_postcode, \
		:consignee_name, :consignee_phone

  validates_presence_of :appointment_time, :shipper_name, :shipper_phone, :shipper_city, :shipper_street, \
    :shipper_postcode, if: :need_pickup?
  validates_presence_of :branch_id, unless: :need_pickup?


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

  def can_plan?
    order_status == "pending" || order_status == "planning"
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
