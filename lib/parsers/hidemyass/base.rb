module Parsers::Hidemyass

  class Base < Parsers::Base
    cattr_accessor :latency, :headers, :host

    @@latency = 1500
    @@headers = [:check_time, :ip, :port, :country_name, :initial_speed, :initial_latency, :type, :anonymity]

    @@host = "http://www.hidemyass.com"

    def url
      @url || "http://www.hidemyass.com/proxy-list/#{@page}"
    end

    def initialize(url = nil)
      @url = url
    end

  end

end

