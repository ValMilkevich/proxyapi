class Api::ProxiesController < ApiController
	expose(:proxy)
	expose(:proxies)

	def index
		render :json => proxies.limit(100)
	end

	def recent
		render :json => proxies.recent.limit(100)
	end

	def fast
		render :json => proxies.fast.limit(100)
	end

	def random
		render :json => Proxy.random.limit(100)
	end

	def show
		render :json => proxy
	end

end
