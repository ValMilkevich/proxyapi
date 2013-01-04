
desc "Proxies"
namespace :proxies do

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