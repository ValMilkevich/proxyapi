class Api::ProxiesController < ApiController
	expose(:proxy)
	expose(:proxies)
	expose(:selectors) { params[:selector] && params[:selector].split(':') }

	def index
		render :json => proxies.limit(100)
	end

	def selector
		render :json => construct_query(proxies).limit(100)
	end

	def recent
		render :json => proxies.recent.limit(100)
	end

	def fast
		render :json => proxies.fast.limit(100)
	end

	def random
		render :json => Proxy.random
	end

	def available
		render :json => proxies.available.limit(100)
	end

	def show
		render :json => proxy
	end

end
