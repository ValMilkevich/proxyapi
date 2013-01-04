class Proxy
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Versioning

	max_versions 100

	field :ip
	field :port
	field :country_name
	field :city_name
	field :latency, type: Integer
	field :ssl
	field :type
	field :anonymity
	field :url

	field :check_count, type: Integer, default: 0
	field :check_time

	belongs_to :country

	validates_presence_of :ip
	validates_presence_of :port
	validates_presence_of :country_name
	validates_numericality_of :latency, greater_than: 0

	before_save :assign_country

	scope :http, where(type: "HTTP")

	def as_json(options={})
    options.merge!(:only => [:_id, :ip, :port, :latency, :type, :check_time] )
    super(options)
  end

	def check_time=(val)
		if val.is_a?(String)
			self[:check_time] = Chronic.parse(val)
		else
			self[:check_time] = val
		end
	end

	def latency=(val)
		self[:latency]= val.to_i
	end


	def self.create_or_update(hash)
		el = self.find_or_initialize_by(ip: hash[:ip], port: hash[:port])
		el.check_count += 1
		el.attributes = hash
		el.check_time ||= Time.now
		el.save
	end

	def self.random
		ne(:check_time => nil, :latency => nil).where({:latency.lt => 1500}).order_by(:check_time.asc).limit(100).sample
	end

	protected

	def assign_country
		self.country = Country.find_or_create_by(name: self.country_name)
	end

end