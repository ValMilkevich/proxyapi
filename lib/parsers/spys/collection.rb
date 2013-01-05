module Parsers::Spys
  class Collection < Base
    attr_accessor :attributes

    def self.each_page
      new.pages.each do |page|
        begin
          new(page).index.map{|hash| yield hash}
        rescue => e
          puts "ERROR: #{e.to_s}"
          []
        end
      end
    end

    def page_numbers
      @pages ||= (1..doc.css('.spy1xx a').map{|a| a['href'].scan(/[\d]+/) }.flatten.compact.map(&:to_i).max) rescue [1]
    end

    def pages
      page_numbers.map{|pn| self.class.host + "/proxies#{pn}/"}
    end

    def index
      return @index if @index.present?
      list = []
      doc.css('tr.spy1x').each do |tr|

        tds = tr.css('td')

        list << {
          :ip => tds[0].css('.spy14').text.split(':').first,
          :port => tds[0].css('.spy14').text.split(':').last,
          :type => tds[1].text,
          :anonymity => tds[2].text,
          :initial_latency => tds[3].text.to_f * 1000,
          :country_name => tds[4].text.gsub(tds[4].css('font font').text, '').strip,
          :city_name => tds[4].css('font font').text.strip,
          :check_time => [tds[6].text.split('-').first.gsub(":", "/"), tds[6].text.split('-').last].compact.join(' '),
          :url => url,
          :from => self.class.from
         }

      end

     @index = list
    end

  end
end