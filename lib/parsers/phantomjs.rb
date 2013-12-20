# encoding: utf-8

class Parsers::Phantomjs

	PHANTOMJS = "phantomjs"
	PORT = 3009
	SCRIPTS = {
		my_ip: File.expand_path('../phantomjs/my_ip.js.coffee', __FILE__),
		load_speed: File.expand_path('../phantomjs/load_speed.js.coffee', __FILE__),
		open:  File.expand_path('../phantomjs/open.js.coffee', __FILE__),
		test_headers: File.expand_path('../phantomjs/test_headers.js.coffee', __FILE__),
		download:  File.expand_path('../phantomjs/download.js', __FILE__),
		binary:  File.expand_path('../phantomjs/binary.js', __FILE__),
		gmail:  File.expand_path('../phantomjs/gmail.js', __FILE__),
	}

	cattr_accessor :debug
  self.debug = true
	attr_accessor :proxy, :url, :headers

	def initialize(opts = {})
		self.opts!(opts)
	end

	def gmail(opts = {})		
		self.opts!(opts)
		self.url ||= "https://accounts.google.com/SignUp?service=mail&continue=http%3A%2F%2Fmail.google.com%2Fmail%2F&ltmpl=default"
		raise "url should be defined" if self.url.blank?
		cmd = "#{[PHANTOMJS, options, SCRIPTS[:gmail], self.url.to_json, "'#{self.headers.to_json}'"].join(' ')}"
		puts cmd if self.class.debug
		`#{cmd}`.strip
	end

	def open(opts = {})
		self.opts!(opts)
		raise "url should be defined" if self.url.blank?
		cmd = "#{[PHANTOMJS, options, SCRIPTS[:open], self.url.to_json, "'#{self.headers.to_json}'"].join(' ')}"
		puts cmd if self.class.debug
		`#{cmd}`.strip
	end

	def download(opts = {})
		self.opts!(opts)
		raise "url should be defined" if self.url.blank?

		cmd = "#{[PHANTOMJS, options, SCRIPTS[:download], self.url.to_json, "'#{self.headers.to_json}'", self.tmp_filename.to_json].join(' ')}"
		puts cmd if self.class.debug
		`#{cmd}`.strip
	end

	def binary(opts = {})
		self.opts!(opts)
		raise "url should be defined" if self.url.blank?

		cmd = "#{[PHANTOMJS, options, SCRIPTS[:binary], self.url.to_json, "'#{self.headers.to_json}'", self.tmp_filename.to_json].join(' ')}"
		puts cmd if self.class.debug
		res = `#{cmd}`.strip
		if res.present?
			Base64.decode64(`#{cmd}`.strip)
		else
			nil
		end
	end

	def my_ip(opts = {})
		self.opts!(opts)

		cmd = "#{[PHANTOMJS, options, SCRIPTS[:my_ip]].join(' ')}"
		puts cmd if self.class.debug
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
		puts cmd if self.class.debug
		eval(`#{cmd}`)
	end

	def test_headers(opts = {})
		opts!(opts)

		cmd = "#{[PHANTOMJS, options, SCRIPTS[:test_headers], PORT, "'#{self.headers.to_json}'"].join(' ')}"
		puts cmd if self.class.debug
		res = `#{cmd}`
		puts res
		JSON.parse(res)["headers"]["User-Agent"] == self.headers["User-Agent"]
	end

	def filename
		URI(self.url).request_uri.split('/').last
	end

	def tmp_filename(filename = nil)
		Dir.mkdir(tmp_dir) if !File.exists?(tmp_dir)
		@tmp_filename ||= File.join(tmp_dir, filename || "#{Time.now.strftime("%Y%m%d")}_#{Digest::SHA1.hexdigest(Time.now.to_i.to_s)}" )
	end

	def tmp_filename!(filename = nil)
		@tmp_filename = nil
		tmp_filename
	end

	def tmp_dir
		File.join("#{Rails.root}/tmp/", "incloack")
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