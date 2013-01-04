class Country
	include Mongoid::Document
	include Mongoid::Versioning

	max_versions 100

	field :name
	validates_presence_of :name

	has_many :proxies

	def as_json(options={})
    options.merge!(:only => [:_id, :name] )
    super
  end

end