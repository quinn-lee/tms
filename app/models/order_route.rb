class OrderRoute < ApplicationRecord
	belongs_to :order, :class_name => 'TransportOrder', :foreign_key => :order_id
	belongs_to :task, :class_name => 'TransportTask', :foreign_key => :task_id

	validates_presence_of :first_location, :end_location
end
