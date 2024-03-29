class Show < ActiveRecord::Base
	include UserContentable
	
	has_many :show_users
	has_many :users, through: :show_users

	has_many :show_watchlists
end
