# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "log/cron.log"
#

every '0 * * * *'  { rake "proxies:hidemyass:get" }
every '10 * * * *' { rake "proxies:incloack:get"}
every '20 * * * *' { rake "proxies:spys:get" }
every '30 * * * *' { rake "proxies:dj:bulk_invoke" }
every '40 * * * *' { rake "proxies:freedailyproxy:get" }

every 1.day do
  rake "proxies:dj:check"
end
