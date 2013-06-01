require 'timeout'

desc "Proxies"
namespace :proxies do

  namespace :dj do
    task :check => :environment  do |task|
      system_activity task.name do
        per_batch = 1000
        0.step(Proxy.where(:last_check.lte => 12.hours.ago).count, per_batch) do |offset|
            ::Proxy.where(:last_check.lte => 12.hours.ago).recent.limit(per_batch).skip(offset).map{|p| p.delayed_check({priority: 2})}
        end
      end
    end

    task :bulk_invoke => :environment do |task|
      system_activity task.name do
        per_batch = 10
        0.step(Delayed::Job.limit(1000).count, per_batch) do |offset|
          begin
            ts = Delayed::Job.skip(offset).limit(per_batch).map{ |dj |Thread.new{ dj.invoke_job; dj.destroy } rescue 'error' }
            puts ts.map(&:join)
          rescue => e
            puts e
          end
        end
      end
    end

  end

  namespace :all do
    task :get => [
      "proxies:incloack:get"
    ]
  end



  desc "incloack.com list"
  namespace :incloack do
    task :get => :environment do |task|
      system_activity task.name do
        Parsers::Incloack::Collection.main_page do |hash|
          begin
            puts "PRX:"
            puts hash.inspect
            puts "==========="

            ::Proxy.create_or_update(hash)
          rescue => e
            puts "ERROR: #{e.to_s}"
            puts hash
            puts e.backtrace
            []
          end
        end
      end
    end
  end

  desc "hidemyass.com list"
  namespace :hidemyass do
    task :get => :environment do |task|
      system_activity task.name do
        Parsers::Hidemyass::Collection.each_page do |hash|
          begin
            ::Proxy.create_or_update(hash)
          rescue => e
            puts "ERROR: #{e.to_s}"
            puts hash
            puts e.backtrace
            []
          end
        end
      end
    end
  end

  desc "spys.ru list"
  namespace :spys do
    task :get => :environment do |task|
      system_activity task.name do
        Parsers::Spys::Collection.each_page do |hash|
          begin
            ::Proxy.create_or_update(hash)
          rescue => e
            puts "ERROR: #{e.to_s}"
            puts hash
            puts e.backtrace
            []
          end
        end
      end
    end
  end

desc "freedailyproxy.com list"
  namespace :freedailyproxy do
    task :get => :environment do |task|
      system_activity task.name do
        Parsers::Freedailyproxy::Collection.each_page do |hash|
          begin
            ::Proxy.create_or_update(hash)
          rescue => e
            puts "ERROR: #{e.to_s}"
            puts hash
            puts e.backtrace
            []
          end
        end
      end
    end
  end


end


def system_activity(name)
  @activity = System::Activity.create(name: name)
  begin
    yield
  rescue => e
    @activity.exceptions = [e.to_s]
    @activity.complete!
  ensure
    @activity.complete!
  end
end