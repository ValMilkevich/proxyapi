class Api::ProxiesController < ApiController
	expose(:proxy)
	expose(:proxies)

	def index
		render :json => proxies.to_json
	end

	def recent
		render :json => proxies.order_by(:check_time.desc)
	end

	def fast
		render :json => proxies.order_by(:latency.asc)
	end

	def random
		render :json => Proxy.random
	end

	def show
		render :json => proxy
	end

end
