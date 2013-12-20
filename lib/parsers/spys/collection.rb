module Parsers::Spys
  class Collection < Base
    attr_accessor :attributes

    def self.each_page
      _self = new
      _self.doc
      _self.check!
      if _self.check!
        _self.pages.each do |page|
          begin
            new(page).index.map{|hash| yield hash}
          rescue => e
            puts "ERROR: #{e.to_s}"
            puts e.backtrace
            []
          end
        end
      end
    end

    def check_string
      '.spy1xx a'
    end

    def page_numbers
      @pages ||= (1..doc.css('.spy1xx a').map{|a| a['href'].scan(/[\d]+/) }.flatten.compact.map(&:to_i).max) rescue [1]
    end

    def pages
      page_numbers
    end

    def index
      return @index if @index.present?
      list = []
      doc.css('tr.spy1x').each do |tr|

        tds = tr.css('td')

        list << {
          :ip => tds[0].css('.spy14').first.children.map { |e| e.text if e.text? }.compact.first,
          :port => tds[0].css('.spy14').first.children.map { |e| e.text if e.text? }.compact.last,
          :type => tds[1].text,
          :anonymity => tds[2].text,
          :initial_latency => tds[3].text.to_f * 1000,
          :country_code => tds[4].text.gsub(tds[4].css('font font').text, '').strip,
          :city_name => tds[4].css('font font').text.gsub('!', '').strip,
          :check_time => [tds[6].text.split('-').first.gsub(":", "/"), tds[6].text.split('-').last].compact.join(' '),
          :url => url,
          :from => self.class.from
         } if tds[0].css('.spy14').first

      end

     @index = list
    end

  end
end