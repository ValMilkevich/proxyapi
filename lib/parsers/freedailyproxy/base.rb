module Parsers::Freedailyproxy
  class Base
    include Parsers::Base
    cattr_accessor :latency, :table_headers, :host, :from

    @@latency = 1500
    @@table_headers = [:proxy_ip, :initital_speed, :stability, :type, :country, :city, :ssl]

    @@host = "http://www.freedailyproxy.com"
    @@from = "freedailyproxy.com"

    def url
      @url || "http://www.freedailyproxy.com/?p=#{@page}"
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

