
desc "Proxies"
namespace :proxies do

  namespace :dj do
    task :check => :environment  do |task|
      system_activity task.name do
        per_batch = 1000
        0.step(Proxy.count, per_batch) do |offset|
            ::Proxy.recent.limit(per_batch).skip(offset).map{|p| p.delayed_check({priority: 2})}
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
        Parsers::Incloack::Collection.each_country do |hash|
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
            p = ::Proxy.find_or_initialize_by(hash)
            p.save
            puts "ERROR: #{p.errors.full_messages}" if p.errors.present?
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
  ensure
    @activity.complete!
  end
end