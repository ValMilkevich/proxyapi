require 'net/https'
require 'open-uri'
require 'iconv'

# encoding: utf-8


# Declares Parsers most common methods, aka headers, net/http functions
#
module Parsers
  module Base
    extend ActiveSupport::Concern

    def raw_document
      @raw_document ||= self.class.open(self.url)
    end

    def doc
      @doc ||= Nokogiri::HTML(raw_document)
    rescue Errno::ECONNRESET, Errno::ETIMEDOUT, Errno::ECONNREFUSED
      refresh!
      doc
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

      # Returns net/http opened page
      #
      def raw_open(url, proxy = false)
        uri = URI(url)
        puts "HOST: #{uri.host}, PROXY: #{[proxy.try(:ip), proxy.try(:port)].join(':')}, REQ: #{uri.request_uri}"
        # puts headers.inspect
        Parsers::Phantomjs.new( :url => url, :proxy => proxy, :headers => headers).open
      end

      # Returns opened page with encoding ( should be stored within individual Parser configuration)
      #
      def open(url)
        res = raw_open(url, Proxy.http.available.recent.fast[rand(10)])
      end

      def binary(url)
        uri = URI(url)
        proxy = Proxy.http.available.recent.fast[rand(10)]
        puts "HOST: #{uri.host}, PROXY: #{[proxy.try(:ip), proxy.try(:port)].join(':')}, REQ: #{uri.request_uri}"
        Parsers::Phantomjs.new( :url => url, :proxy => proxy, :headers => headers).binary
      end
    end

  end
end