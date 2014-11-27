require 'net/https'
require 'open-uri'

# encoding: utf-8


# Declares Parsers most common methods, aka headers, net/http functions
#
module Parsers
  module Base
    extend ActiveSupport::Concern

    attr_accessor :proxy, :raw_document, :proxy_check_count

    PROXY_LATENCY = 1500
    CONNECTION_TIMEOUT = 15
    MAX_RETRY = 3
    MAX_PROXY_CHECKS = 3

    PROXY_CONNECTION_TIMEOUT = 15
    PROXY_MAX_RETRY = 1

    def raw_document
      @raw_document ||= self.class.open(self.url, self.proxy || set_proxy)
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
      @index = @doc = @raw_document = @proxy = nil
    end

    def index!
      refresh!
      index
    end

    def check!
      return true if !proxy
      return false if !doc

      self.proxy_check_count = 0

      while doc.css(self.check_string).blank? do
        raise "MAX_PROXY_CHECKS" if proxy_check_count >= MAX_PROXY_CHECKS

        self.proxy_check_count += 1
        self.refresh!
        self.set_proxy
        puts "** NEW PROXY: #{self.proxy.ip}:#{self.proxy.port}"
      end

      return true
    rescue => e
      puts e.to_s
      puts e.backtrace
      return false
    end

    def check_string
      'body'
    end

    def set_proxy
      return @proxy if @proxy && @proxy.check! && @proxy.available && @proxy.latency < ::Parsers::Base::PROXY_LATENCY
      @proxy = Proxy.http.available.fast.where(:latency.lte => ::Parsers::Base::PROXY_LATENCY).limit(100).sample

      @proxy.blank? ? nil : self.proxy

    end

    module ClassMethods
      # Returns the most basic headers configuration ( should be possible variable?, to mimic different users)
      #
      def headers
        @headers ||= Parsers::Bullshit::Headers.new.random_header
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
      def open(url, prx = false)
        res = raw_open(url, prx)
      end

      def binary(url, proxy = nil)
        uri = URI(url)

        puts "HOST: #{uri.host}, PROXY: #{[proxy.try(:ip), proxy.try(:port)].join(':')}, REQ: #{uri.request_uri}"
        status = Timeout.timeout(::Parsers::Base::CONNECTION_TIMEOUT) do
          Parsers::Phantomjs.new( :url => url, :proxy => proxy, :headers => headers).binary
        end
      end
    end

  end
end
