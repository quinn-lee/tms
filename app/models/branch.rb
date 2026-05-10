class Branch < ApplicationRecord
	validates_presence_of :branch_code, :branch_name, :city, :address, 
		:postcode, message: "Can't be blank"
  validates :branch_code, uniqueness: true

end
