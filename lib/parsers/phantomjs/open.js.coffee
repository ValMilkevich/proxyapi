page = require("webpage").create();
server = require("webserver").create()
system = require("system")
host = undefined
port = undefined

width = Math.round(800 + Math.random() * 1000)
height = Math.round(600 + Math.random() * 1000)

phantom.viewportSize = {width: width, height: height};

if system.args.length isnt 3
  console.log "Usage: server.js <url> <headers>"
  phantom.exit 1
else

  url = system.args[1]
  headers = JSON.parse('' + system.args[2])
  page.customHeaders = headers


  page.open url, (status) ->
    console.log status
    if status isnt "success"
      console.log "<html></html>"
      phantom.exit();
    else
      console.log page.evaluate -> document.documentElement.innerHTML
      phantom.exit();
