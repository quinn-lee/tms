class LoadingScanRecord < ApplicationRecord
	belongs_to :order, :class_name => 'TransportOrder', :foreign_key => :order_id
	belongs_to :driver, :class_name => 'User', :foreign_key => :driver_id
end
