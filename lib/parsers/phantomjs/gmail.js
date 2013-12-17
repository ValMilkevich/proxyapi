
phantom.casperPath = "/opt/casperjs";
phantom.injectJs("/opt/casperjs/bin/bootstrap.js");


var headers, height, host, page, port, server, system, url, width, captcha, image_url;


// https://id.heroku.com/account/accept/2542405/7ce500ecd36caf3dc68e6782948dcd11
// Usage heroku_request.js URL password

var casper = require("casper").create();
var server = require("webserver").create();
var system = require("system");
var child_process = require("child_process")


var casper = require('casper').create({
    clientScripts:  [
        // 'includes/jquery.js',      // These two scripts will be injected in remote
        // 'includes/underscore.js'   // DOM on every request
    ],
    pageSettings: {
        loadImages:  true,        // The WebPage instance used by Casper will
        loadPlugins: true         // use these settings
    },    
    verbose: true,                  // log messages will be printed out to the console
    waitTimeout: 1000,
    viewportSize: {
    	width: Math.round(800 + Math.random() * 1000), 
    	height: Math.round(600 + Math.random() * 1000)
    }
});


var url = '' + system.args[4]
var password = '' + system.args[5]

casper.start();

casper.then(function() {
	this.open(system.args[1], {
        method: 'get',
        headers: JSON.parse('' + system.args[2])
    });

});

casper.then(function() {
	image_url = casper.evaluate(function() {
		return document.querySelector('#recaptcha_image img').src
	})
	console.log(image_url)	


});

casper.then(function() {
	child_process.execFile('open', [image_url], null, null )
	require('system').stdout.writeLine('CaptchaCode: ');
 	captcha = require('system').stdin.readLine();
})
  
casper.then(function() {
	console.log('captcha:' +  captcha)
    casper.evaluate(function(password) {    	
        document.querySelector('#user_password').value = password;
        document.querySelector('#user_password_confirmation').value = password;
        document.querySelector('form[method="post"]').submit();
    }, password);
});


casper.then(function() {
    // console.log(this.getPageContent())
    this.exit();
});

casper.run();

