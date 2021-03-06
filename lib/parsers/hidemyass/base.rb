module Parsers::Hidemyass
  class Base
    include Parsers::Base
    cattr_accessor :latency, :table_headers, :host, :from

    @@latency = 1500
    @@table_headers = [:check_time, :ip, :port, :country_name, :initial_speed, :initial_latency, :type, :anonymity]

    @@host = "http://proxylist.hidemyass.com"
    @@from = "proxylist.hidemyass.com"

    def url
      @url || "http://proxylist.hidemyass.com/#{@page}"
    end

    def initialize(page = nil)
      @page = page
    end

    def self.headers
      super.merge(
        "Host" => self.from,
        "Referer" => self.host
      )
    end
  end
end

