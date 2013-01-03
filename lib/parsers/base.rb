require 'net/https'
require 'iconv'
require 'open-uri'

# encoding: utf-8


# Declares Parsers most common methods, aka headers, net/http functions
#
module Parsers

  class Base

    protected
    class << self
      # Returns the most basic headers configuration ( should be possible variable?, to mimic different users)
      #
      def headers
        @headers ||= Parsers::Bullshit::Headers.new.random_header
      end

      def ip_port
        @ip_port ||= Parsers::Proxy.new.ip_port
      end

      # Returns net/http opened page
      #
      def raw_open(url)
        uri = URI(url)
        req = Net::HTTP::Get.new(uri.request_uri)

        headers.each do |key, value|
          req[key] = value
        end

          res = Net::HTTP.start(uri.hostname, uri.port) {|http|
            http.request(req)
          }

        res
      end

      # Returns opened page with encoding ( should be stored within individual Parser configuration)
      #
      def open(url)
        res = raw_open(url)

        ic = Iconv.new('UTF-8', 'windows-1251')
        ic.iconv(res.body)
      end
    end

  end
end