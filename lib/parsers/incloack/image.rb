module Parsers::Incloack
  class Image
  	attr_accessor :url

    @@dictionary_path = "#{Rails.root}/lib/parsers/incloack/images/"

    def initialize(url)
      @url = url
    end

    def file
    	begin
	      @file ||= Parsers::Base.raw_open(@url).body.to_s
	    rescue
	    	nil
	    end
    end

    def detect_port
    	return nil if !file

      dictionary.each do |k|
        return k if Digest::SHA1.hexdigest(File.open(dictionary_image_path(k)).read.to_s) == Digest::SHA1.hexdigest(file)
      end

      puts "NOT PARSED: #{@url}"
      if Rails.env == "development"
	      exists = false
	      Dir[File.join(@@dictionary_path, "*")].flatten.each do |k|
	        exists = true if Digest::SHA1.hexdigest(File.open(k).read.to_s) == Digest::SHA1.hexdigest(file)
	      end
	      if !exists
		      filename = '_' + url.split(/\/+/).last
		      f = File.open(File.join(@@dictionary_path, filename), 'w+')
		      f.binmode
		      f.write(Parsers::Base.raw_open(@url).body)
		      f.close
		    end
	    end

      return nil

    end

    def dictionary
    	Dir[File.join(@@dictionary_path, "*")].map{|a| a.split('/').last.scan(/\A[\d]+/)}.flatten
    end

    def dictionary_image_path(port)
			File.join(@@dictionary_path, "#{port}.gif")
    end

    # get
    # File.open(Rails.root.to_s + "/lib/parsers/images/3128_2.gif").read.to_s == File.open(Rails.root.to_s + "/lib/parsers/images/8080.gif").read.to_s
  end
end