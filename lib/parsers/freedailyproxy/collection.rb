module Parsers::Freedailyproxy
  class Collection < Base
    attr_accessor :attributes

    def self.each_page
      new.pages.each do |page|
        new(page).index.map do |hash|
          begin
            yield hash
          rescue => e
            puts "ERROR: #{e.to_s}"
            []
          end
        end
      end
    end

    def page_numbers
      @pages ||= (1..doc.css('.pagination .middle a').map{|a| a['href'].scan(/[\d]+/) }.flatten.compact.map(&:to_i).max) rescue [1]
    end

    def pages
      page_numbers.map{|pn| self.class.host + "?p=#{pn}"}
    end

    def index
      return @index if @index.present?
      list = []
      doc.css('.proxy-section ul li').each do |li|

        list << {
          :check_time => li.css('div.lasttime').text,
          :ip => li.css('div.ip').text.split(':').first,
          :port => li.css('div.ip').text.split(':').last,
          :initial_speed => li.css("div.speed").text,
          :initial_latency => (10.0 / i.css("div.speed").text.to_f rescue 1000),
          :anonymity => li.css("div.type").text,
          :country_name => li.css("div.country").first["title"],
          :country_name => li.css("div.city").first["title"],
          :ssl => li.css("div.ssl-yes").present?,
          :type => li.css("div.ssl-yes").present? ? "HTTPS" : "HTTP",
          :url => url,
          :from => self.class.from
         }

      end

     @index = list
    end

  end
end