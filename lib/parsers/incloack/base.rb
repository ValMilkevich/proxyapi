module Parsers::Incloack
  class Base
  	include Parsers::Base

    cattr_accessor :latency, :headers, :host, :from
    attr_accessor :url_options

    @@latency = 1500
    @@table_headers = [:ip, :port, :country_name, :city_name, :initial_latency, :type, :anonymity, :check_time, :port_image_url]

    @@host = "http://incloak.com"
    @@from = "incloak.com"

    def url
      "http://incloak.com/proxy-list/?#{url_options_string}"
    end

    def url_options_string
    	url_options.reject{|k,v| v.blank?}.to_query
    end

		def initialize(hash = {})
      @url_options = hash
      @latency = hash[:latency] || @@latency
      @country = hash[:country]
    end


		def self.headers
      super.merge(
        "Host" => self.from,
        "Referer" => self.host,
        "Cookie" => "PAPVisitorId=#{Parsers::Bullshit::Headers.rand_string[32]}; __asc=#{r = Parsers::Bullshit::Headers.rand_string[27]}; __auc=#{r}; #{Parsers::Bullshit::Headers.google_cookies}"
      )
    end


  end

end
