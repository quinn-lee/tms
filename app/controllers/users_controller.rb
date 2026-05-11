class UsersController < ApplicationController
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
end
