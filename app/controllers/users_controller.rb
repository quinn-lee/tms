class UsersController < ApplicationController
  before_action :auth_admin, only: [:new, :create, :edit, :update]
  before_action :auth_staff, except: [:edit_password, :change_password]

  def index
    @all_staffs = User.where(staff_grade: ['dispatcher', 'appeal_handler'])
    @pagy, @users = pagy(:offset, @all_staffs.order("id desc"))
  end

  def customers
    @all_customers = User.where(staff_grade: ['customer'])
    @pagy, @users = pagy(:offset, @all_customers.order("id desc"))
  end

  def drivers
    @all_drivers = User.where(staff_grade: ['driver'])
    @pagy, @users = pagy(:offset, @all_drivers.order("id desc"))
  end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params.require(:user)
      .permit(:nickname, :password, :password_confirmation, :user_name, 
        :id_card, :user_phone, :staff_grade))
    ActiveRecord::Base.transaction do
      begin
        @user.save!
        flash[:success] = "Staff Created Successful"
        redirect_to users_path
      rescue => e
        render :new, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    ActiveRecord::Base.transaction do
      begin
        if params[:user][:password].present? or params[:user][:password_confirmation].present?
          @user.update!(params.require(:user)
            .permit(:nickname, :password, :password_confirmation, :user_name, 
            :id_card, :user_phone, :staff_grade, :status))
        else
          @user.update!(params.require(:user).permit(:nickname, :user_name, 
            :id_card, :user_phone, :staff_grade, :status))
        end
        flash[:success] = "Staff Updated Successful"
        redirect_to users_path
      rescue => e
        render :edit, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
  end

	def new_customer
		@user = User.new
	end

	def create_customer
		@user = User.new(params.require(:user)
      .permit(:nickname, :password, :password_confirmation, :customer_code, 
        :customer_name, :customer_type, :contact_person, :contact_phone, 
        :contact_address, :credit_level))
		@user.staff_grade = "customer"
    ActiveRecord::Base.transaction do
      begin
        @user.save!
        flash[:success] = "Customer Created Successful"
        redirect_to customers_users_path
      rescue => e
        render :new_customer, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end

  def edit_customer
    @user = User.find(params[:id])
  end

  def update_customer
    @user = User.find(params[:id])
    ActiveRecord::Base.transaction do
      begin
        if params[:user][:password].present? or params[:user][:password_confirmation].present?
          @user.update!(params.require(:user)
            .permit(:nickname, :password, :password_confirmation, :customer_code, 
              :customer_name, :customer_type, :contact_person, :contact_phone, 
              :contact_address, :credit_level, :status))
        else
          @user.update!(params.require(:user).permit(:nickname, :customer_code, 
              :customer_name, :customer_type, :contact_person, :contact_phone, 
              :contact_address, :credit_level, :status))
        end
        flash[:success] = "Customer Updated Successful"
        redirect_to customers_users_path
      rescue => e
        render :edit_customer, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
  end

	def new_driver
		@user = User.new
	end

	def create_driver
		@user = User.new(params.require(:user)
      .permit(:nickname, :password, :password_confirmation, :user_name, 
        :id_card, :user_phone, :driver_license, :license_type, :license_expire_date))
		@user.staff_grade = "driver"
    ActiveRecord::Base.transaction do
      begin
        @user.save!
        flash[:success] = "Driver Created Successful"
        redirect_to drivers_users_path
      rescue => e
        render :new_driver, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end

  def edit_driver
    @user = User.find(params[:id])
  end

  def update_driver
    @user = User.find(params[:id])
    
    ActiveRecord::Base.transaction do
      begin
        if params[:user][:password].present? or params[:user][:password_confirmation].present?
          @user.update!(params.require(:user)
            .permit(:nickname, :password, :password_confirmation, :user_name, :status,
            :id_card, :user_phone, :driver_license, :license_type, :license_expire_date))
        else
          @user.update!(params.require(:user).permit(:nickname, :user_name, :status,
            :id_card, :user_phone, :driver_license, :license_type, :license_expire_date))
        end
    
        flash[:success] = "Driver Update Successful"
        redirect_to drivers_users_path
      rescue => e
        render :edit_driver, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
  end

  def edit_password
  end

  def change_password
    if current_user.valid_password?(params[:old_password])
      current_user.password_confirmation = params[:password_confirmation]
      current_user.password = params[:password]
      if current_user.save
        flash[:success] = "Password Updated Successful"
      else
        flash[:error] = current_user.errors.full_messages.join(",")
      end
    else
      flash[:error] = "The Old Password Is Not Right"
    end
    redirect_to edit_password_users_path
  end
end
