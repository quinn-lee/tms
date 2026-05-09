class UsersController < ApplicationController
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
        redirect_to users_path
      rescue => e
        render :new_customer, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end
end
