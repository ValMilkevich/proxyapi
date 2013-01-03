class Api::ProxiesController < ApiController

	def index
		render :json => Proxy.all
	end
end
