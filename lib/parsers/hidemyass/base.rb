module Parsers::Hidemyass
  class Base
    include Parsers::Base
    cattr_accessor :latency, :table_headers, :host, :from

    @@latency = 1500
    @@table_headers = [:check_time, :ip, :port, :country_name, :initial_speed, :initial_latency, :type, :anonymity]

    @@host = "http://www.hidemyass.com"
    @@from = "hidemyass.com"

    def url
      @url || "http://www.hidemyass.com/proxy-list/#{@page}"
    end

    def initialize(url = nil)
      @url = url
    end

    def self.headers
      super.merge(
        "Host" => self.from,
        "Referer" => self.host
      )
    end
  end
end

