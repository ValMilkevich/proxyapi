
phantom.casperPath = "casperjs";

// Then you need to inJect caspers's bootstrap.js file.

phantom.injectJs("casperjs/bin/bootstrap.js");

// Now you can instantiate a casper object and play with it in the shell.
var casper = require('casper').create();
var fs = require('fs')
var system = require('system')

var url = system.args[1]
var headers = JSON.parse('' + system.args[2])
var image = null

casper.start(url, function() {
    logo = this.evaluate(function() {
    		url = this.window.location.href
        return __utils__.getBase64(url)
    });
});

casper.run(function(){
	this.echo(logo)
	phantom.exit();
});