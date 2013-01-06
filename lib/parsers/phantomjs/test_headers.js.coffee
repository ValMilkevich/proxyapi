page = require("webpage").create();
server = require("webserver").create()
system = require("system")
host = undefined
port = undefined


if system.args.length isnt 3
  console.log "Usage: server.js <some port> <headers>"
  phantom.exit 1
else

  headers = JSON.parse('' + system.args[2])
  page.customHeaders = headers
  port = system.args[1]

  listening = server.listen(port, (request, response) ->
    response.write "<p>"
    response.write JSON.stringify(request, null, 4)
    response.write "</p>"
    response.close()
  )

  unless listening
    console.log "could not create web server listening on port " + port
    phantom.exit();
  url = "http://127.0.0.1:" + port
  page.open url, (status) ->
    if status isnt "success"
      console.log "FAIL to load the address"
      phantom.exit();
    else
      console.log page.evaluate -> document.querySelector('p').innerText
      phantom.exit();

