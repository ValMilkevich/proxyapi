module Parsers::Incloack
  class Collection < Base
    attr_accessor :attributes

    @@countries = [
      "AF","AL","A1","AR","AT","BD","BA","BR","BG","KH","CA","CL","CN",
      "CO","HR","CZ","DK","EC","EG","FR","GE","DE","GH","GR","GT","HK",
      "HU","IN","ID","IR","IQ","IE","IL","IT","JP","KZ","KE","KR","LV",
      "LY","LT","MK","MY","MX","MD","MN","NA","NP","NL","NG","NO","PK",
      "PY","PE","PH","PL","RO","RS","SG","SK","SI","ZA","ES","SD","SE",
      "SY","TW","TZ","TH","TN","TR","UA","GB","US","VE","VN","ZW"
    ]

    def self.each_country
      @@countries.each do |country|
        begin
          country_collection = new({:country => country, :latency => @@latency})
          if country_collection.index.size < 64
            country_collection = new({:country => country, :latency => @@latency * 10 })
          end

          country_collection.index.map{|hash| yield hash}
        rescue => e
          puts "ERROR: #{e.to_s}"
          []
        end
      end
    end

    def initialize(hash = {})
      @latency = hash[:latency] || @@latency
      @country = hash[:country]
    end

    def index
      return @index if @index.present?

      list_hash = []
      doc.css('div#tgr table.pl tr').map{|a| [*a.css('td').map(&:text), (a.css('td img').first['src'] rescue nil)].compact }.each do |arr|
        hash = {}
        @@headers.each_with_index do |h, i|
          hash[h] = arr[i]
        end
        port_image_url = hash.delete(:port_image_url)

        hash[:port] = Parsers::Incloack::Image.new( self.class.host + port_image_url.to_s).detect_port if port_image_url
        hash[:url] = url
        hash[:from] = self.class.from
        list_hash << hash
      end

      @index ||= list_hash
    end

  end
end