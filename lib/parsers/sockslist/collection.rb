module Parsers::Sockslist
  class Collection < Base
    attr_accessor :attributes

    def self.each_page
      _self = new
      _self.doc

      if _self.check!
        _self.pages.each do |page|
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
    end

    def check_string
      '#pages a'
    end

    def page_numbers
      @pages ||= (1..doc.css('#pages a').map{|a| a['href'].scan(/[\d]+/) }.flatten.compact.map(&:to_i).max) rescue [1]
    end

    def pages
      page_numbers
    end

    def index
      return @index if @index.present?
      list = []
      doc.css('.proxytbl tr').each do |tr|

        next if tr.attribute('align')
        puts tr.text
        list << {
          :check_time => Time.now - (Chronic.parse(tr.css('td.t_checked').text) - Chronic.parse('00:00:00')) ,
          :ip => tr.css('td.t_ip').text.gsub(/[\s\t\n]/, '').strip,
          :port => tr.css('td.t_port').text.strip.scan(/[\d]{3,7}$/).first,
          :anonymity => "SOCKS",
          :initial_latency => 1,
          :country_name => tr.css("td.t_country").text.gsub(/[\t\n]/, '').strip,
          :type => "SOCKS#{tr.css("td.t_type").text.gsub(/[\s\t\n]/, '').strip}",
          :url => url,
          :from => self.class.from
         }

      end

     @index = list
    end

  end
end
