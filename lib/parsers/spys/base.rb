module Parsers::Spys
  class Base
  	include Parsers::Base

    cattr_accessor :host, :from

    @@host = "http://spys.ru"
    @@from = "spys.ru"

    def url
      @url || "http://spys.ru/proxies/#{@page}/"
    end

    def initialize(page = nil)
      @page = page
    end

		def self.headers
      super.merge(
        "Host" => self.from,
        "Referer" => self.host,
        "Cookies" => nil
      )
    end


  end

end
