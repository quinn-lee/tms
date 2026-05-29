class BranchesController < ApplicationController
  before_action :auth_staff
  
  def index
    @all_branches = Branch.all
    @pagy, @branches = pagy(:offset, @all_branches.order("id desc"))
  end

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

  def edit
    @branch = Branch.find(params[:id])
  end

  def update
    @branch = Branch.find(params[:id])
    ActiveRecord::Base.transaction do
      begin
        @branch.update!(params.require(:branch).permit(:branch_code, 
          :branch_name, :province, :city, :address, :postcode, :latitude, 
          :longitude, :contact_person, :contact_phone, :status))
        flash[:success] = "Branch Updated Successful"
        redirect_to branches_path
      rescue => e
        render :edit, status: :unprocessable_entity
        raise ActiveRecord::Rollback,"rollback!"
      end
    end
  end
end
