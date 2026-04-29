class SessionsController < ApplicationController
  layout false

  def new

  end

  def create
    if account = login(params[:nickname], params[:password])
      if account.status=="out_of_service" or account.status == "resigned"
        logout
        flash[:error] = "User's status is #{account.status}, Can't Login"
        redirect_to new_session_path
      else
        flash[:success] = 'Login Successful'
        redirect_to root_path
      end
    else
      flash[:error] = 'Username or Password error!'
      redirect_to new_session_path
    end
  end

  def destroy
    logout
    flash[:notice] = "Logout Successful"
    redirect_to new_session_path
  end
end
