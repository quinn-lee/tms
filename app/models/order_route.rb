class OrderRoute < ApplicationRecord
	belongs_to :order, :class_name => 'TransportOrder', :foreign_key => :order_id

	validates_presence_of :first_location, :end_location
end
