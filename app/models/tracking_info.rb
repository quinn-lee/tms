class TrackingInfo < ApplicationRecord
	mount_uploaders :images, AvatarUploader
	
end
