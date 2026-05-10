class Branch < ApplicationRecord
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
