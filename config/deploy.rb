require "capistrano/ext/multistage"
require "rvm/capistrano"
require "bundler/capistrano"
require "delayed/recipes"

#  RVM settings
#
set :rvm_ruby_string, '1.9.3'
set :rvm_type,        :user

#  Multistage settings
#
set :stages, %w{staging production}
set :default_stage, "production"

set :whenever_command, "bundle exec whenever"
set :whenever_environment, defer { stage }
set :whenever_identifier,  defer { "#{application}_#{stage}" }

#  Repository settings
#
set :scm, :git
set :repository,  "git@github.com:ValMilkevich/proxyapi.git"
set :branch, "master"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

#  Deployment server settings
#
server "144.76.36.48", :app, :web, :db, :primary => true
set :user, "app"
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 3

namespace :deploy do

  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
  end

  task :start do ; end

  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :dj do

  task :start, :roles => [:app] do
    run "cd #{release_path} && RAILS_ENV=#{stage} bundle exec ruby script/rails runner 'Delayed::Backend::Mongoid::Job.create_indexes'"
    run "cd #{release_path} && RAILS_ENV=#{stage} bundle exec ruby script/delayed_job stop"
  end

  task :stop, :roles => [:app] do
    run "cd #{release_path} && RAILS_ENV=#{stage} bundle exec ruby script/delayed_job stop"
  end

  task :restart, :roles => [:app] do
    run "cd #{release_path} && RAILS_ENV=#{stage} bundle exec ruby script/delayed_job restart"
  end
end

namespace :whenever do
  task :restart, :roles => [:app] do
    "bundle exec whenever --update-crontab"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'

# Delayed jobs
#
set :delayed_job_args, "-n 2"

after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"
after "deploy:restart", "whenever:restart"
