class UsersController < ApplicationController

	def import
	end

	def table
	end

	def csv_import
    if params[:file]
    	User.import_csv(params[:file].path)
		end

    redirect_to url_for(controller: :users, action: :import)
    return
	end
end
