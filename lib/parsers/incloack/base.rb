module Parsers::Incloack

  class Base < Parsers::Base
    cattr_accessor :latency, :headers, :host

    @@latency = 1500
    @@headers = [:ip, :port, :country_name, :city_name, :initial_latency, :type, :anonymity, :check_time, :port_image_url]

    @@host = "http://incloak.com"

    def url
      "http://incloak.com/proxy-list/?country=#{@country}&maxtime=#{@latency}"
    end

  end

end

