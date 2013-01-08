class HerokuApp
	@@config = YAML.load(File.open(Rails.root + 'config/api/heroku.yml'))[Rails.env]

	cattr_accessor :config

	def initialize
		request
	end

	def request
		@request ||= Heroku::API.new(@@config.symbolize_keys.slice(:username, :password))
	end

	def request!
		@request = nil
		request
	end


	def method_missing name, *args, &block
		if request.respond_to?(name)
			return (instance_variable_defined?(iname(name, *args)) && instance_variable_get(iname(name, *args))) || instance_variable_set(iname(name, *args), request.send(name, *args, &block).status == 200 ? request.send(name, *args, &block).body : {})
		end

		super
	end

	def iname(name, *args)
		"@#{name}_#{args.map(&:to_s).join('_')}"
	end
end