# encoding: utf-8

require 'capybara/dsl'
require 'capybara/poltergeist'

class Parsers::Proxygeist
	include Capybara::DSL

	def initialize(host, proxy)

		name, driver = self.class.register_driver(proxy)
		Capybara.app_host = host
		Capybara.javascript_driver = name
		Capybara.current_driver = name
		Capybara.default_driver = name

	end

	def open(url, headers = {})

		page.driver.headers = headers
	  visit(url)
	  page
	end

	# :phantomjs (String) - A custom path to the phantomjs executable
	# :debug (Boolean) - When true, debug output is logged to STDERR
	# :logger (Object responding to puts) - When present, debug output is written to this object
	# :timeout (Numeric) - The number of seconds we'll wait for a response when communicating with PhantomJS. Default is 30.
	# :inspector (Boolean, String) - See 'Remote Debugging', above.
	# :js_errors (Boolean) - When false, Javascript errors do not get re-raised in Ruby.
	# :window_size (Array) - The dimensions of the browser window in which to test, expressed as a 2-element array, e.g. [1024, 768]. Default: [1024, 768]
	# :phantomjs_options (Array) - Additional command line options to be passed to PhantomJS, e.g. ['--load-images=no', '--ignore-ssl-errors=yes']
	# :port (Fixnum) - The port which should be used to communicate with the PhantomJS process. Default: 44678.



	def self.register_driver(proxy, name = :proxy_poltergeist)
		return name, Capybara.register_driver(:proxy_poltergeist) do |app|
		  options = {
		    phantomjs_options: [
		      "--disk-cache=no",
		      "--ignore-ssl-errors=yes",
		      "--load-images=no",
		      ("--proxy=#{proxy.ip}:#{proxy.port}" if proxy)
		    ].compact,
		    # :debug => true,
		    :js_errors => false
		  }

		  Capybara::Poltergeist::Driver.new(app, options)
		end
	end

end