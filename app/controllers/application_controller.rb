class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Pagy::Method

  private
  def auth_user
    unless logged_in?
      flash[:error] = "Please Login"
      redirect_to new_session_path
    end
  end

  def auth_customer
    unless logged_in? and current_user.is_customer?
      logout
      flash[:notice] = "Please Login as customer"
      redirect_to new_session_path
    end
  end

  def auth_staff
    unless logged_in? and (current_user.is_staff? or current_user.is_admin?)
      logout
      flash[:notice] = "Please Login as staff"
      redirect_to new_session_path
    end
  end

  def auth_admin
    unless logged_in? and current_user.is_admin?
      logout
      flash[:notice] = "Please Login as admin"
      redirect_to new_session_path
    end
  end

  def auth_driver
    unless logged_in? and current_user.is_driver?
      logout
      flash[:notice] = "Please Login as driver"
      redirect_to new_session_path
    end
  end
end
