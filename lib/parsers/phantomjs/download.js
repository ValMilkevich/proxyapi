
phantom.casperPath = "casperjs";

// Then you need to inJect caspers's bootstrap.js file.

phantom.injectJs("casperjs/bin/bootstrap.js");

// Now you can instantiate a casper object and play with it in the shell.
var casper = require('casper').create();
var fs = require('fs')
var system = require('system')

var url = system.args[1]
var headers = JSON.parse('' + system.args[2])
var filename = system.args[3]

casper.options.pageSettings = {
	"userAgent": headers["User-Agent"],
	"referer": headers["Referer"],
	"accept": headers["Accept"],
	"host": headers["Host"],
	"connection": headers["Connection"],
	"acceptLanguage": headers["Accept-Language"],
	"acceptEncoding": headers["Accept-Encoding"],
	"cookie": headers["Cookie"]
}

casper.start(url, function(){
	this.download(url, filename);
});

casper.run(function() {
	this.exit();
});

console.log(filename);