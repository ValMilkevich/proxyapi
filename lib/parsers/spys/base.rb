module Parsers::Spys
  class Base
  	include Parsers::Base

    cattr_accessor :host, :from

    @@host = "http://spys.ru"
    @@from = "spys.ru"

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
