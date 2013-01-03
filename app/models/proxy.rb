class Proxy
	include Mongoid::Document
	include Mongoid::Timestamps
	field :ip
	field :port
	field :country_name
	field :city_name
	field :latency
	field :ssl
	field :type

	validates_presence_of :ip
	validates_presence_of :port

end