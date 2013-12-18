
phantom.casperPath = "/opt/casperjs";

// Then you need to inJect caspers's bootstrap.js file.

phantom.injectJs("/opt/casperjs/bin/bootstrap.js");

// Now you can instantiate a casper object and play with it in the shell.
var casper = require('casper').create({
	timeout: 20000
});
var fs = require('fs');
var system = require('system');

var url = system.args[1];
var headers = JSON.parse('' + system.args[2]);
var image = null;
var logo = null;

casper.start(url, function() {
    logo = this.evaluate(function(url) {
        return __utils__.getBase64(url)
    }, url);
});
casper.then(function(){
	console.log(logo)
})

casper.run()
// casper.then(function(){
//     this.echo(logo);
//     this.exit();
// })
