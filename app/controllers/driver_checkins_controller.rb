class DriverCheckinsController < ApplicationController
	def index
		@all_dcis = DriverCheckin.all
    @pagy, @dcis = pagy(:offset, @all_dcis.order("id desc"))
	end
end
