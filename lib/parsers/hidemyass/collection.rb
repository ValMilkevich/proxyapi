module Parsers::Hidemyass
  class Collection < Base
    attr_accessor :attributes

    def self.each_page
      _self = new
      _self.doc
      _self.check!
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
      '.pagination li a'
    end

    def page_numbers
      begin
      @pages ||= (1..doc.css('.pagination li a').map{|a| a['href'].to_s.scan(/[\d]+/).first.to_s.to_i }.flatten.compact.map(&:to_i).max)
      rescue => e
        puts e.to_s
        puts e.backtrace
        return [1]
      end
    end

    def pages
      page_numbers
    end

    def all_children(el, options, lmbd = lambda{} )
      el.children.map{|c| ((c.children.present? ? all_children(c, options, lmbd) : c) if lmbd[c] ) }.compact.flatten
    end

    def index
      return @index if @index.present?
      list = []
      doc.css('#listable tr').each do |tr|

        tds = tr.css('td')
        next if tds.size < 5

        time_string = tds[0].text
        time_string = time_string.gsub('secs', ' seconds ago').strip
        time_string = time_string.gsub(/([\d]+)m/, "#{$1} minutes ago").strip

        list << {
          :check_time => Chronic.parse( time_string ),
          :ip => childs = all_children(tds[1], {:tr => tr}, lambda{|el|
              ["text", "span"].include?(el.name) &&
              (el['style'].blank? || !(el['style'] =~ /none/)) &&
              !el.ancestors('td').first.css('style').text.scan(/\.([^{]+)\{display:none/).flatten.include?(el['class'])
            }).join,
          :port => tds[2].text.strip,
          :country_name => tds[3].text.strip,
          # :initial_speed => (tds[4].css('.progress-indicator').first || {})['rel'].to_s.strip,
          :initial_latency => (tds[5].css('.progress-indicator').first || {})['rel'].to_s.strip,
          :type => tds[6].text.to_s.strip,
          :anonymity => tds[7].text.to_s.strip,
          :url => url,
          :from => self.class.from
         }

      end

     @index = list
    end

  end
end
