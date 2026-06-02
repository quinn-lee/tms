class LoadingScanRecordsController < ApplicationController
	def index
		@all_lsrs = LoadingScanRecord.all
    @pagy, @lsrs = pagy(:offset, @all_lsrs.order("id desc"))
	end
end
