class Api::ProxiesController < ApiController
	expose(:proxy)
	expose(:proxies)
	expose(:selectors) { params[:selector] && params[:selector].split(':') }

	def index
		render :json => proxies.limit(100)
	end

	def selector
		render :json => construct_query(proxies)
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

	def available
		render :json => proxies.available.limit(100)
	end

	def show
		render :json => proxy
	end

	protected

	def construct_query(obj)
		([:ip, :port, :latency, :type, :availability, :available, :last_check, :checks_count] & selector_hash.keys).each do |k|
			v = selector_hash[k]

			if v.is_a?(Array)
				obj = obj.in(k => v)
			elsif v.is_a?(Range)
				obj = obj.gte(k => v.first).lte(k => v.last)
			else
				obj = obj.where(k => v)
			end
		end

		([:order] & selector_hash.keys).each do |k|
			vs = selector_hash[k]
			vs.to_a.flatten.each do |v|
				if v && v.gsub!('.asc', '')
					order = [:ip, :port, :latency, :type, :availability, :available, :last_check, :checks_count] & [v.to_sym]
					obj = obj.asc(order)
				elsif v && v.gsub!('.desc', '')
					order = [:ip, :port, :latency, :type, :availability, :available, :last_check, :checks_count] & [v.to_sym]
					obj = obj.desc(order)
				end
			end
		end
		obj
	end

	def selector_hash
		return @selector_hash if @selector_hash.present?

		hash = {}
		selectors.each do |selector|
			if condition = selector.scan(/\(([^\)]+)\)/).flatten.first
				condition_hash = nil
				if condition.scan(',').present?
					condition_hash = condition.to_s.split(',')
				elsif condition.scan('-').present?
					condition_hash = (condition.to_s.split('-').flatten.first.to_s..condition.to_s.split('-').flatten.last.to_s)
				elsif ['true', 'false'].include?(condition.downcase)
					condition_hash = eval(condition)
				else
					condition_hash = condition.to_s
				end
			end
			hash[selector.gsub(/\([^\)]+\)/, '').to_s] = condition_hash
		end
		@selector_hash = hash.symbolize_keys
	end
end
