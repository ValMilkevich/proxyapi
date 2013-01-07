class Admin::DashboardController < AdminController
	expose(:heroku){ HerokuApp.new }

	def show
	end

end