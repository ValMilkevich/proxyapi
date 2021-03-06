# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "log/cron.log"
#

every 60.minutes do
  rake "proxies:hidemyass:get"
  rake "proxies:incloack:get"
  rake "proxies:spys:get"
  rake "proxies:freedailyproxy:get"
  rake "proxies:sockslist:get"
end

every 60.minutes do
  rake "proxies:dj:bulk_invoke"
end

every 8.hours do
  rake "proxies:dj:check"
  # rake "proxies:clean"
end

