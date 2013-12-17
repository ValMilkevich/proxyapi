require 'net/https'
require 'open-uri'

# encoding: utf-8


# Declares Parsers most common methods, aka headers, net/http functions
#
module Parsers
  module Base
    extend ActiveSupport::Concern

    PROXY_LATENCY = 1500
    CONNECTION_TIMEOUT = 15
    MAX_RETRY = 3

    PROXY_CONNECTION_TIMEOUT = 5
    PROXY_MAX_RETRY = 1

    def raw_document
      @raw_document ||= self.class.open(self.url)
    end

    def doc
      @doc ||= Nokogiri::HTML(raw_document)
    rescue Errno::ECONNRESET, Errno::ETIMEDOUT, Errno::ECONNREFUSED, Timeout::Error => e
      if self.retry_count < MAX_RETRY
        retry!
        refresh!
        doc
      else
        raise e
      end
    end

    def retry_count
      @retry_county ||= 0
    end

    def retry!
      @retry_county ||= 0
      @retry_county += 1
      print("+#{self.retry_count}:")
      self.retry_count
    end


    def refresh!
      @index = @doc = @raw_document = nil
    end

    def index!
      refresh!
      index
    end

    module ClassMethods
      # Returns the most basic headers configuration ( should be possible variable?, to mimic different users)
      #
      def headers
        @headers ||= Parsers::Bullshit::Headers.new.random_header
      end

      def proxy
        return @proxy if @proxy && @proxy.check! && @proxy.available && @proxy.latency < ::Parsers::Base::PROXY_LATENCY
        @proxy = Proxy.http.available.fast.where(:latency.lte => ::Parsers::Base::PROXY_LATENCY).limit(100).sample

        @proxy.blank? ? nil : self.proxy

      end

      # Returns net/http opened page
      #
      def raw_open(url, prx = false)

        uri = URI(url)
        puts "HOST: #{uri.host}, PROXY: #{[prx.try(:ip), prx.try(:port)].join(':')}, REQ: #{uri.request_uri}"
        # puts headers.inspect

        status = Timeout.timeout(::Parsers::Base::CONNECTION_TIMEOUT) do
          Parsers::Phantomjs.new( :url => url, :proxy => prx, :headers => headers).open
        end
      end

      # Returns opened page with encoding ( should be stored within individual Parser configuration)
      #
      def open(url)
        res = raw_open(url, proxy)
      end

      def binary(url)
        uri = URI(url)

        puts "HOST: #{uri.host}, PROXY: #{[proxy.try(:ip), proxy.try(:port)].join(':')}, REQ: #{uri.request_uri}"
        status = Timeout.timeout(::Parsers::Base::CONNECTION_TIMEOUT) do
          Parsers::Phantomjs.new( :url => url, :proxy => proxy, :headers => headers).binary
        end
      end
    end

  end
end