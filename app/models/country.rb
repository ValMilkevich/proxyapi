class Country
	include Mongoid::Document

	field :name
	field :code

	validates_presence_of :name

	has_many :proxies

	def as_json(options={})
    options.merge!(:only => [:_id, :name] )
    super
  end

end
