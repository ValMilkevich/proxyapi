class Api::Countries::ProxiesController < Api::ProxiesController
	expose(:country)
	expose(:proxies, ancestor: :country)

	def index
		render :json => proxies.limit(100)
	end
end
