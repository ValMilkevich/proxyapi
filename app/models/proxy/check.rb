class ::Proxy::Check
	include Mongoid::Document
	include Mongoid::Timestamps

	@@latency_check_url = 'http://www.google.com'

	field :available
	field :latency
	field :exception

	embedded_in :proxy

	validates_presence_of :latency

	before_validation :check_latency, on: :create
	after_create :update_proxy!

	def available_to_i
		available ? 1 : 0
	end

	def check_latency
		self.class.check_latency(self.proxy, self)
	end

	def update_proxy!
		proxy.from_last_check!
	end

	def self.check_latency(proxy_id, self_id)
		proxy = proxy_id.is_a?(::Proxy) ? proxy_id : ::Proxy.find_by(id: proxy_id.to_s)
		check = self_id.is_a?(::Proxy::Check) ? self_id : proxy.checks.find_by(id: self_id)

		puts "Proxy::Check for #{proxy.ip}:#{proxy.port} #{proxy.country_name}"
		response, time = self.test_request(proxy)

    check.available = !!(response.code =~ /2\d\d/)
    check.latency = time * 1000 # in milliseconds
  rescue Errno::ECONNREFUSED => e
  	check.available = false
  	check.exception = e.to_s
  rescue => e
  	check.available = false
  	check.exception = e.to_s
  ensure
  	check.latency ||= ::Parsers::Base::CONNECTION_TIMEOUT * 1000
  	check
  end

	def self.test_request(prx, url = @@latency_check_url, retry_count = nil)
		retry_count ||= 0
		begin
			status = Timeout.timeout(::Parsers::Base::CONNECTION_TIMEOUT) do
				uri = URI(url)
		    req = Net::HTTP::Get.new(uri.request_uri)
		    t1 = Time.now
		    resp = Net::HTTP::Proxy(prx.ip, prx.port).start(uri.hostname, uri.port) {|http| http.request(req)}
		    t2 = Time.now
				if resp.code =~ /3[\d]{2,}/
					test_request(prx, resp.header['location'])
				else
					return resp, (t2 - t1)
				end
			end
		status
	rescue Errno::ECONNRESET, Errno::ETIMEDOUT, Errno::ECONNREFUSED, Timeout::Error => e
		if retry_count < ::Parsers::Base::MAX_RETRY
			retry_count += 1
			test_request(prx, url)
		else
			raise e
		end
	end

	end

end