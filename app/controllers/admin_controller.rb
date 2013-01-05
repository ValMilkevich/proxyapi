class AdminController < ApplicationController
	layout "admin"

	before_filter :authenticate_user!

	protected
	def authenticate_user!
		redirect_to :root, :flash => {:error => "Access denied"} if !(current_user && current_user.admin?)
	end
end
