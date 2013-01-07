# variable in the phantom global object.
phantom.casperPath = "casperjs"

# Then you need to inJect caspers's bootstrap.js file.
phantom.injectJs "casperjs/bin/bootstrap.js"

# Now you can instantiate a casper object and play with it in the shell.
casper = require("casper").create()
system = require("system")
url = system.args[1]
url = system.args[1]
casper.start url, ->
  @download url, filename

casper.run ->
  @exit()

console.log "done"