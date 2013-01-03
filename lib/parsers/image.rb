class Parsers::Image
	@@dictionary = {
		"8080" => "#{Rails.root}/lib/parsers/images/8080.gif",
		"3128" => "#{Rails.root}/lib/parsers/images/3128.gif",
		"3129" => "#{Rails.root}/lib/parsers/images/3129.gif",
		"8089" => "#{Rails.root}/lib/parsers/images/8089.gif",
		"80" => "#{Rails.root}/lib/parsers/images/80.gif"
	}

	def initialize(url)
		@url = url
	end

	def file
		@file ||= Parsers::Base.raw_open(@url).body.to_s
	end

	def detect_port
		@@dictionary.each do |k,v|
			return k if Digest::SHA1.hexdigest(File.open(v).read.to_s) == Digest::SHA1.hexdigest(file)
		end
	end

	# get
	# File.open(Rails.root.to_s + "/lib/parsers/images/3128_2.gif").read.to_s == File.open(Rails.root.to_s + "/lib/parsers/images/8080.gif").read.to_s
end