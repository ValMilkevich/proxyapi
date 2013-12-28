module Parsers::Sockslist
  class Base
    include Parsers::Base
    cattr_accessor :latency, :table_headers, :host, :from

    @@latency = 1500
    @@table_headers = [:proxy_ip, :proxy_port, :country, :type, :last_check]

    @@host = "http://sockslist.net/"
    @@from = "sockslist.net"

    def url
      @url || "http://sockslist.net/proxy/server-socks-hide-ip-address/#{@page}"
    end

    def initialize(page = nil)
      @page = page
    end

    def self.headers
      super.merge(
        "Referer" => self.host
      )
    end
  end
end

