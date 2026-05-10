class BranchesController < ApplicationController
	def new
		@branch = Branch.new
	end

	def create
		@branch = Branch.new(params.require(:branch)
      .permit(:branch_code, :branch_name, :province, :city, :address, 
      	:postcode, :latitude, :longitude, :contact_person, :contact_phone))
    ActiveRecord::Base.transaction do
      begin
        @branch.save!
        flash[:success] = "Branch Created Successful"
        redirect_to branches_path
      rescue => e
        render :new, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
	end
end
