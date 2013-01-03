class Parsers::Incloackcom::Base
	cattr_accessor :url
  @@latency = 500
  @@url = "http://incloak.com/proxy-list/?country=RU&maxtime=#{@@latency}&type=h"
  @@headers = [:ip, :port, :country, :city, :speed, :type, :anonymity, :last_check, :port_image_url]

  def main_document
  	Parsers::Base.open(self.class.url)
  end

  def doc
		@doc ||= Nokogiri::HTML(main_document)
  end

  def list
    return @list if @list.present?

    list_hash = []
    doc.css('div#tgr table.pl tr').map{|a| [*a.css('td').map(&:text), (a.css('td img').first['src'] rescue nil)].compact }.each do |arr|
      hash = {}
      @@headers.each_with_index do |h, i|
        hash[h] = arr[i]
      end

      hash[:port] = Parsers::Image.new("http://incloak.com" + hash[:port_image_url].to_s).detect_port if hash[:port_image_url]
      list_hash << hash
    end

    @list ||= list_hash
  end

  def list!
  	refresh!
  	list
  end

  def refresh!
  	@list = @doc = nil
  end

  def ip_port
  	[:ip, :port].map{|k| list.select{|h| h[:ssl] == "false" && h[:port] == "80" || h[:port] == "8080" }.sample[k]}
  end

  def hash
  	lambda{|pr|
  		return {
				ip: pr.xpath('prx:ip').text,
  			port: pr.xpath('prx:port').text,
  			latency: pr.xpath('prx:latency').text,
  			ssl: pr.xpath('prx:ssl').text,
  			country_code: pr.xpath('prx:country_code').text,
  			type: pr.xpath('prx:type').text
  		}
  	}
  end
end

