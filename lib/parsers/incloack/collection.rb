module Parsers::Incloack
  class Collection < ::Parsers::Incloack::Base
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
        country_collection = new({:country => country, :maxtime => @@latency})
        if country_collection.index.size < 64
          country_collection = new({:country => country, :maxtime => @@latency * 10 })
        end

        country_collection.index.map do |hash|
          begin
            yield hash
          rescue => e
            puts "ERROR: #{e.to_s}"
          end
        end
      end
    end

    def self.main_page
      new(:maxtime => @@latency ).index.map do |hash|
        begin
          yield hash
        rescue => e
          puts "ERROR: #{e.to_s}"
        end
      end
    end

    def index
      return @index if @index.present?

      list_hash = []
      doc.css('div#tgr table.pl tr').map{|a| [*a.css('td').map(&:text), (a.css('td img').first['src'] rescue nil)].compact }.each do |arr|
        puts arr.inspect

        hash = {}
        @@table_headers.each_with_index do |h, i|
          hash[h] = arr[i]
        end

        port_image_url = hash.delete(:port_image_url)
        # binding.pry
        hash[:check_time] = Chronic.parse(arr[@@table_headers.index(:check_time)]) rescue Time.now

        hash[:port] = Parsers::Incloack::Image.new( self.class.host + port_image_url.to_s).detect_port if port_image_url
        hash[:url] = url
        hash[:from] = self.class.from
        list_hash << hash
      end

    ensure
      @index = list_hash
      return  @index
    end

  end
end
