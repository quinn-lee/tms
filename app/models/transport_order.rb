class TransportOrder < ApplicationRecord

  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  has_many :order_routes, :class_name => 'OrderRoute', :dependent => :destroy, :foreign_key => :order_id
	
  validates_presence_of :goods_name, :goods_type, :goods_weight, :goods_volume, \
		:goods_quantity, :start_address, :shipper_name, :shipper_phone, :end_address, \
		:consignee_name, :consignee_phone

	before_validation :setup, :on => :create


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
