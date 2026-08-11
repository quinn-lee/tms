class DeliveryArea < ApplicationRecord
	belongs_to :branch, :class_name => 'Branch', :foreign_key => :branch_id

	validates_presence_of :area_code, :area_name, :branch_id, :postcodes, message: "Can't be blank"
  validates :area_code, uniqueness: true
end
