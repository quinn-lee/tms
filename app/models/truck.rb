class Truck < ApplicationRecord
	validates_presence_of :truck_plate, message: "Can't be blank"
  validates :truck_plate, :gps_device_id, uniqueness: true

  validates_inclusion_of :truck_type, :in => ['3.5t','12t','18t']
  validates_inclusion_of :truck_status, :in => ['suspension','operation','maintenance']

	before_validation :setup, :on => :create


	private
	def setup
    self.truck_status ||= "operation"
  end
end
