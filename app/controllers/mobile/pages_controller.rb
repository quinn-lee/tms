class Mobile::PagesController < ApplicationController
  before_action :auth_driver
  def profile
  end

  def checkin
    ActiveRecord::Base.transaction do
      begin
        dc = DriverCheckin.new(params.require(:driver_checkin).permit(:checkin_type, checkin_photos: []))
        dc.driver_id = current_user.id
        dc.checkin_time = Time.now
        dc.save!
        flash[:success] = "#{dc.checkin_type&.capitalize} Successful"
        redirect_to mobile_pages_profile_path
      rescue => e
        flash[:error] = e.message
        redirect_to mobile_pages_profile_path
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
  end
end
