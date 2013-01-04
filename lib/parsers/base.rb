require 'net/https'
require 'iconv'
require 'open-uri'

# encoding: utf-8


# Declares Parsers most common methods, aka headers, net/http functions
#
module Parsers

  class Base
    def raw_document
      @raw_document ||= Parsers::Base.open(self.url)
    end

    def doc
      @doc ||= Nokogiri::HTML(raw_document)
    end

    def refresh!
      @index = @doc = @raw_document = nil
    end

    def index!
      refresh!
      index
    end

    protected

    class << self
      # Returns the most basic headers configuration ( should be possible variable?, to mimic different users)
      #
      def headers
        @headers ||= Parsers::Bullshit::Headers.new.random_header
      end

      # Returns net/http opened page
      #
      def raw_open(url, proxy = false)
        puts "URL: #{url}"

        uri = URI(url)
        req = Net::HTTP::Get.new(uri.request_uri)

        headers.each do |key, value|
          req[key] = value
        end

        if proxy
            puts "Proxy:"
            puts "IP&Port: #{[proxy.ip, proxy.port]}"

            res = Net::HTTP::Proxy(proxy.ip, proxy.port).start(uri.hostname, uri.port) {|http|
              http.request(req)
            }
          else
            res = Net::HTTP.start(uri.hostname, uri.port) {|http|
              http.request(req)
            }
          end

          res
        end

      # Returns opened page with encoding ( should be stored within individual Parser configuration)
      #
      def open(url)
        res = raw_open(url, Proxy.http.random)

        ic = Iconv.new('UTF-8', 'windows-1251')
        ic.iconv(res.body)
      end
    end

  end
end