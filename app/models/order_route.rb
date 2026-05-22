class OrderRoute < ApplicationRecord
	belongs_to :order, :class_name => 'TransportOrder', :foreign_key => :order_id

	validates_presence_of :first_location, :end_location, \
	:expected_departure_time, :expected_arrival_time

	after_create :set_detail

	private
	def set_detail
    first_branch = Branch.find_by(branch_code: first_location)
    end_branch = Branch.find_by(branch_code: end_location)
    if first_branch.present?
	    self.first_detail = {
	    	city: first_branch&.city,
	    	street: first_branch&.address,
	    	streetnum: "",
	    	housenum: "",
	    	postcode: first_branch&.postcode
	    }
	  else
	  	self.first_detail = {
	    	city: self.order.shipper_city,
	    	street: self.order.shipper_street,
	    	streetnum: self.order.shipper_streetnum,
	    	housenum: self.order.shipper_housenum,
	    	postcode: self.order.shipper_postcode
	    }
	  end
    if end_branch.present?
    	self.last_detail = {
	    	city: end_branch&.city,
	    	street: end_branch&.address,
	    	streetnum: "",
	    	housenum: "",
	    	postcode: end_branch&.postcode
	    }
    else
    	if node_order == 1
    		self.last_detail = {
    			city: self.order.shipper_city,
		    	street: self.order.shipper_street,
		    	streetnum: self.order.shipper_streetnum,
		    	housenum: self.order.shipper_housenum,
		    	postcode: self.order.shipper_postcode
		    }
    	else
    		self.last_detail = {
    			city: self.order.consignee_city,
		    	street: self.order.consignee_street,
		    	streetnum: self.order.consignee_streetnum,
		    	housenum: self.order.consignee_housenum,
		    	postcode: self.order.consignee_postcode
		    }
    	end
    end
    self.save!
  end
end
