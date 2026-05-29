class DriverCheckin < ApplicationRecord
	mount_uploaders :checkin_photos, AvatarUploader
end
