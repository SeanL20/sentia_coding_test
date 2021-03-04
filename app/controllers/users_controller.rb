class UsersController < ApplicationController

	def import
	end

	def table
		users_all = User.all.includes(:locations, :affiliations)

		# checks if the params exists for the page.
		if (params.keys & ["search", "page", "sort_column", "sort_style"]).any?
			@users = load_users(users_all)
		else
			@current_page = 1
			@max_page = (users_all.length.to_f/10).ceil
			@users = users_all.limit(10)

			@users = mapping_data(@users)
		end

		# have the prev button display or not
		@prev_btn_display = !params[:page].blank? && params[:page].to_i != 1 && params[:page] != "nil"
		# have the next button display or not
		@next_btn_display = params[:page].to_i != @max_page
	end

	def csv_import
    if params[:file]
    	# imports the data from csv using the user model method.
    	User.import_csv(params[:file].path)
		end

    redirect_to url_for(controller: :users, action: :import)
    return
	end

	def load_users(users_all)
		if params[:search] != "nil"
			# Search the users data with mutli column searchs.
			users_all = users_all.search(params[:search])
		end
		# maps the user data into hash
		users_all = mapping_data(users_all)
		if params[:sort_column] != "nil" && params[:sort_style] != "nil"
			if params[:sort_style] == "asc"
				users_all = users_all.sort_by{ |k| k["#{params[:sort_column]}"] }
			else
				users_all = users_all.sort_by{ |k| k["#{params[:sort_column]}"] }.reverse!
			end
		end
		if params[:page] != "nil"
			# set current page for the pagination
			@current_page = params[:page].to_i
			# set max page for the pagination
			@max_page = (users_all.length.to_f/10).ceil
			start_num = 10*(@current_page-1)
			end_num = 10*@current_page
			# limits the data to only display max of 10 items depending on the start and end num
			users_all = users_all[start_num, end_num]
		else
			# set current page for the pagination
			@current_page = 1
			# set max page for the pagination
			@max_page = (users_all.length.to_f/10).ceil
			# limits the data to only display max of 10 items
			users_all = users_all[0, 10]
		end

		return users_all
	end

	def mapping_data(users)
		users_hash = users.map { |e| {
			"full_name" => e.full_name,
			"location" => e.locations.pluck(:title).join(", "),
			"species" => e.species,
			"gender" => e.gender,
			"affiliations" => e.affiliations.pluck(:title).join(", "),
			"weapon" => e.weapon,
			"vehicle" => e.vehicle
		}}
		return users_hash
	end
end
