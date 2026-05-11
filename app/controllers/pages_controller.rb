class PagesController < ApplicationController
  def home
    if current_user.is_driver?
      redirect_to mobile_transport_tasks_path and return
    end
  end
end
