
desc "Proxies"
namespace :proxies do

  namespace :dj do
    task :check => :environment do
      per_batch = 1000
      0.step(Proxy.count, per_batch) do |offset|
          Proxy.recent.limit(per_batch).skip(offset).map{|p| p.delayed_check({priority: 2})}
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
    task :get => :environment do
      Parsers::Incloack::Collection.each_country do |hash|
        Proxy.create_or_update(hash)
      end
    end
  end
end