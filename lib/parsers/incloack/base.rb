module Parsers::Incloack
  class Base
  	include Parsers::Base

    cattr_accessor :latency, :headers, :host, :from

    @@latency = 1500
    @@table_headers = [:ip, :port, :country_name, :city_name, :initial_latency, :type, :anonymity, :check_time, :port_image_url]

    @@host = "http://incloak.com"
    @@from = "incloak.com"

    def url
      "http://incloak.com/proxy-list/?country=#{@country}&maxtime=#{@latency}"
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
