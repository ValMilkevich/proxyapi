require 'net/https'
require 'open-uri'

class Proxy
	include Mongoid::Document
	include Mongoid::Timestamps
	include ::Proxy::Formatter
	include Mongoid::CommonScopes

	THRESHOLD_AVAILABILITY_CLEAN = 0.1
	THRESHOLD_CHECKS_COUNT_CLEAN = 5

	field :ip
	field :port
	field :country_name
	field :country_code
	field :city_name
	field :latency, type: Integer
	field :ssl
	field :type, type: Array
	field :anonymity
	field :url
	field :from

	field :availability, type: Float, default: 1.0
	field :available, type: Boolean, default: true
	field :last_check, type: Time
	field :checks_count, type: Integer, default: 0

	belongs_to :country
	embeds_many :checks, class_name: "::Proxy::Check"

	validates_presence_of :ip
	validates_presence_of :port
	validates_numericality_of :latency, greater_than: 0
	validates_format_of :ip, with: /\A[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}$/

	before_save		:assign_country

	scope :available, where(available: true)
	scope :unavailable, where(available: false)
	scope :recent, order_by(:last_check.desc)
	scope :fast, order_by(:latency.asc)
	scope :http, where(type: "HTTP")

	def as_json(options={})
    options.merge!(:only => [:_id, :ip, :port, :latency, :type, :availability, :available, :last_check, :checks_count] )
    super(options)
  end

	def self.create_or_update(hash)
		el = self.find_or_initialize_by(ip: hash[:ip], port: hash[:port])
		el.attributes = hash
		el.last_check ||= Time.now
		el.save
		el.delayed_check
	end

	def self.random
		ne(:check_time => nil, :latency => nil).where({:latency.lt => 1500}).order_by(:check_time.asc).limit(100).sample
	end

	def from_last_check!
		update_attributes(
			latency: self.checks.avg(:latency).round(2),
			availability: self.checks.avg(:available_to_i).round(2),
			available: self.checks.last.available,
			last_check: self.checks.last.created_at,
			checks_count: self.checks.count
		)
	end

	def delayed_check(hash = {priority: 1})
		self.class.delay(hash).check(self._id)
	end

	def check!
		self.check
		self.reload
	end

	def check
		self.class.check(self._id)
	end

	def self.check(id)
		return nil if where(id: id).first.blank?
		
		where(id: id).first.checks.create
	end

	def check_time=(val)
		if val.is_a?(String)
			self[:last_check] = Chronic.parse(val) rescue Time.now
		else
			self[:last_check] = val
		end
	end

	def country_code=(val)
		self.country_name ||= Country.any_of({ code: /#{val}/i }, { long_code: /#{val}/i }).first.try(:name)
	end

	def self.google_chart_timespan
		3.days
	end

	def self.google_chart_timestep
		3600 * 2
	end

	def self.google_chart_steps
		((Time.now - google_chart_start) / google_chart_timestep).ceil
	end

	def self.google_chart_start
		::Proxy.google_chart_timespan.ago.at_beginning_of_day.to_date.to_time(:utc)
	end

	def self.google_chart_range
		(1..google_chart_steps).map{ |h| google_chart_start + h * google_chart_timestep
			}.reject{ |t|
				t > Time.now
			}
	end

	def self.google_chartize(collection, method, range = nil)
		range ||= ::Proxy.google_chart_range
    sent_arr = range.map{|a| [a.strftime("%H:00, %d %h"), collection.lte(method => a).count] }
  end

	protected

	def assign_country
		if self.country_name
			self.country = Country.where(name: /#{self.country_name}/i).first || Country.create(name: self.country_name)
		end
	end

end