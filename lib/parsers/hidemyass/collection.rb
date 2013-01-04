module Parsers::Hidemyass
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
      @pages ||= (1..doc.css('.pagination li a').map{|a| a['href'].scan(/[\d]+/) }.flatten.compact.map(&:to_i).max) rescue [1]
    end

    def pages
      page_numbers.map{|pn| self.class.host + "/proxy-list/#{pn}"}
    end

    def all_children(el, options, lmbd = lambda{} )
      el.children.map{|c| ((c.children.present? ? all_children(c, options, lmbd) : c) if lmbd[c] ) }.compact.flatten
    end

    def index
      return @index if @index.present?
      list = []
      doc.css('#listtable tr').each do |tr|

        tds = tr.css('td')

        list << {
          :check_time => (tds[0].text + ' ago').strip,
          :ip => childs = all_children(tds[1], {:tr => tr}, lambda{|el|
              ["text", "span"].include?(el.name) &&
              (el['style'].blank? || !(el['style'] =~ /none/)) &&
              !el.ancestors('td').first.css('style').text.scan(/\.([^{]+)\{display:none/).flatten.include?(el['class'])
            }).join,
          :port => tds[2].text.strip,
          :country_name => tds[3].text.strip,
          :initial_speed => (tds[4].css('.speedbar').first || {})['rel'].to_s.strip,
          :initial_latency => (tds[5].css('.speedbar').first || {})['rel'].to_s.strip,
          :type => tds[6].text.to_s.strip,
          :anonymity => tds[7].text.to_s.strip,
          :url => url
         }

      end

     @index = list
    end

  end
end