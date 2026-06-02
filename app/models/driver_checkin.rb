class DriverCheckin < ApplicationRecord
	mount_uploaders :checkin_photos, AvatarUploader
	belongs_to :driver, :class_name => 'User', :foreign_key => :driver_id
end
