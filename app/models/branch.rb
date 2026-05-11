class Branch < ApplicationRecord
	has_many :trucks, :class_name => 'Truck', :dependent => :destroy, :foreign_key => :branch_id
	
	validates_presence_of :branch_code, :branch_name, :city, :address, 
		:postcode, message: "Can't be blank"
  validates :branch_code, uniqueness: true
  validates_inclusion_of :status, :in => ['in_service','out_of_service']
  
	before_validation :setup, :on => :create


	private
	def setup
    self.status ||= "in_service"
  end
end
