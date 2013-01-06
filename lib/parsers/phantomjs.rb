# encoding: utf-8

class Parsers::Phantomjs

	PHANTOMJS = "phantomjs"
	PORT = 3009
	SCRIPTS = {
		my_ip: File.expand_path('../phantomjs/my_ip.js.coffee', __FILE__),
		load_speed: File.expand_path('../phantomjs/load_speed.js.coffee', __FILE__),
		open:  File.expand_path('../phantomjs/open.js.coffee', __FILE__),
		test_headers: File.expand_path('../phantomjs/test_headers.js.coffee', __FILE__),
	}

	attr_accessor :proxy, :url, :headers

	def initialize(opts = {})
		self.opts!(opts)
	end

	def open(opts = {})
		self.opts!(opts)
		raise "url should be defined" if self.url.blank?
		cmd = "#{[PHANTOMJS, options, SCRIPTS[:open], self.url.to_json, "'#{self.headers.to_json}'"].join(' ')}"
		puts cmd
		`#{cmd}`.strip
	end

	def my_ip(opts = {})
		self.opts!(opts)

		cmd = "#{[PHANTOMJS, options, SCRIPTS[:my_ip]].join(' ')}"
		puts cmd
		`#{cmd}`.strip
	end

	def test_proxy(opts = {})
		self.opts!(opts)

		raise "provide proxy" if self.proxy.blank?
		res = self.my_ip
		puts "Proxy ip: #{proxy.ip}"
		puts "Detected ip: #{res}"

		res == "#{proxy.ip}"
	end

	def load_speed(opts = {})
		opts!(opts)
		raise "url should be defined" if self.url.blank?

		cmd = "#{[PHANTOMJS, options, SCRIPTS[:load_speed], self.url].join(' ')}"
		puts cmd
		eval(`#{cmd}`)
	end

	def test_headers(opts = {})
		opts!(opts)

		cmd = "#{[PHANTOMJS, options, SCRIPTS[:test_headers], PORT, "'#{self.headers.to_json}'"].join(' ')}"
		puts cmd
		res = `#{cmd}`
		puts res
		JSON.parse(res)["headers"]["User-Agent"] == self.headers["User-Agent"]
	end

	def options
		[
      "--disk-cache=no",
      "--ignore-ssl-errors=yes",
      "--load-images=yes",
      ("--proxy=#{proxy.ip}:#{proxy.port}" if proxy)
    ].compact
	end

	def opts!(opts)
		raise "(opts) should be hash"if !opts.is_a?(Hash)

		self.url = opts[:url] || self.url
		self.proxy = opts[:proxy] || self.proxy
		self.headers = opts[:headers] || self.headers || Parsers::Bullshit::Headers.new.random_header
	end

end