Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
  	collection do 
  		get :import
  		get :table, path: 'table(/:search)(/:page)(/:sort_column)(/:sort_style)'
			post :csv_import
  	end
  end
end
