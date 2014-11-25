source 'https://rubygems.org'

ruby '2.1.3'

if RUBY_VERSION =~ /1.9/
    Encoding.default_external = Encoding::UTF_8
    Encoding.default_internal = Encoding::UTF_8
end

gem 'rails', ">=4.0.0"


# Additional check to solve encoding issues
if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'daemons'
gem 'rails-api', :git => "git://github.com/rails-api/rails-api.git"
gem 'mongoid'
gem 'bson_ext'
gem 'chronic'
gem 'decent_exposure', :git => "https://github.com/voxdolo/decent_exposure.git", :branch => "master", :ref => "HEAD"
gem 'delayed_job_mongoid'
gem 'nokogiri'
gem 'jquery-rails'
gem 'libv8', '~> 3.16.14'
gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'devise'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'whenever', :require => false
gem 'socksify'

group :production do
	gem 'uglifier'
end

group :development do
  gem 'pry'
  gem 'capistrano'
  gem 'rvm-capistrano'
end
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
