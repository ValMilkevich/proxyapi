module Parsers::Bullshit

	class Headers
		attr_reader :attrs

	def initialize *attrs
		@attrs = [
			"User-Agent", "Accept", "Accept-Charset", "Accept-Encoding", "Accept-Language", "Cache-Control", "Connection", "Cookie"
			] if attrs.blank?

	end

	def random_header
		self.attrs.inject({}){|memo, attr| memo[attr] = self.class.send(attr.tableize.singularize).sample; memo; }
	end

	class << self

		def rand_string
			Digest::SHA1.hexdigest Time.now.to_s + 'bullshit'
		end

		def rand_numbers
			rand.to_s[2,40]
		end

		def cooky
			[
				"b=b; b=b; muid=#{rand_numbers[0,11] }; OABLOCK=#{rand_numbers[0,3]}.#{rand_numbers[0,10]}; OAID=#{rand_string[0,32]}; b=b; fe_typo_user=#{rand_string[0,32]}; __utma=#{rand_numbers[0,9]}.#{rand_numbers[0,10]}.#{rand_numbers[0,6]}.#{rand_numbers[0,10]}.#{rand_numbers[0,10]}.#{rand_numbers[0,2]}; __utmb=#{rand_numbers[0,9]}.#{rand(9)}.#{rand_numbers[0,2]}.#{rand_numbers[0,10]}; __utmc=#{rand_numbers[0,9]}; __utmz=#{rand_numbers[0,9]}.#{rand_numbers[0,10]}.#{rand(9)}.#{rand(9)}.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)",
				"b=b; b=b; muid=#{rand_numbers[0,11] }; OABLOCK=#{rand_numbers[0,3]}.#{rand_numbers[0,10]}; OAID=#{rand_string[0,32]};",
				"b=b; fe_typo_user=#{rand_string[0,32]};"
			]
		end

		def accept
			[
				"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8,application/json",
				"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
				"text/html,text/plain;q=0.5"
			]
		end

		def accept_charset
			[
				"ISO-8859-1,utf-8",
				"ISO-8859-1,utf-8;q=0.7,*;q=0.3",
				"ISO-8859-1,utf-8;q=0.8",
				"ISO-8859-1,US-ASCII,UTF-8;q=0.8,ISO-10646-UCS-2;q=0.6",
			]
		end

		def accept_encoding
			[
				"*",
				"compress;q=0.5;q=1.0",
				"identity;q=0.5,*;q=0",
				"deflate,sdch",
				"deflate"
			]
		end

		def accept_language
			[
				'ru',
				":en-US,en;q=0.8",
				":en;q=0.8",
				":ru;q=0.9;en;q=0.8",
			]

		end

		def cache_control
			[
				":max-age=0",
				"public",
				"max-age=31556926",
				"no-cache",
				"no-store"
			]
		end

		def connection
			[
				"keep-alive",
				"Keep-Alive"
			]
		end

		def user_agent
			[
				"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)",
				"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
				"Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.0 )",
				"Mozilla/4.0 (compatible; MSIE 5.5; Windows 98; Win 9x 4.90)",
				"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.1) Gecko/2008070208 Firefox/3.0.1",
				"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14",
				"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.2.149.29 Safari/525.13",
				"Mozilla/4.8 [en] (Windows NT 6.0; U)",
				"Mozilla/4.8 [en] (Windows NT 5.1; U)",
				"Opera/9.25 (Windows NT 6.0; U; en)",
				"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; en) Opera 8.0",
				"Opera/7.51 (Windows NT 5.1; U) [en]",
				"Opera/7.50 (Windows XP; U)",
				"Avant Browser/1.2.789rel1 (http://www.avantbrowser.com)",
				"Mozilla/5.0 (Windows; U; Win98; en-US; rv:1.4) Gecko Netscape/7.1 (ax)",
				"Mozilla/5.0 (Windows; U; Windows XP) Gecko MultiZilla/1.6.1.0a",
				"Opera/7.50 (Windows ME; U) [en]",
				"Mozilla/3.01Gold (Win95; I)",
				"Mozilla/2.02E (Win95; U)",
				"Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/125.2 (KHTML, like Gecko) Safari/125.8",
				"Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/125.2 (KHTML, like Gecko) Safari/85.8",
				"Mozilla/4.0 (compatible; MSIE 5.15; Mac_PowerPC)",
				"Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.7a) Gecko/20050614 Firefox/0.9.0+",
				"Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-US) AppleWebKit/125.4 (KHTML, like Gecko, Safari) OmniWeb/v563.15",
				"Mozilla/5.0 (X11; U; Linux; i686; en-US; rv:1.6) Gecko Debian/1.6-7",
				"Mozilla/5.0 (X11; U; Linux; i686; en-US; rv:1.6) Gecko Epiphany/1.2.5",
				"Mozilla/5.0 (X11; U; Linux i586; en-US; rv:1.7.3) Gecko/20050924 Epiphany/1.4.4 (Ubuntu)",
				"Mozilla/5.0 (compatible; Konqueror/3.5; Linux) KHTML/3.5.10 (like Gecko) (Kubuntu)",
				"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081216 Ubuntu/8.04 (hardy) Firefox/2.0.0.19",
				"Mozilla/5.0 (X11; U; Linux; i686; en-US; rv:1.6) Gecko Galeon/1.3.14",
				"Konqueror/3.0-rc4; (Konqueror/3.0-rc4; i686 Linux;;datecode)",
				"Mozilla/5.0 (compatible; Konqueror/3.3; Linux 2.6.8-gentoo-r3; X11;",
				"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20050614 Firefox/0.8",
				"ELinks/0.9.3 (textmode; Linux 2.6.9-kanotix-8 i686; 127x41)",
				"ELinks (0.4pre5; Linux 2.6.10-ac7 i686; 80x33)",
				"Links (2.1pre15; Linux 2.4.26 i686; 158x61)",
				"Links/0.9.1 (Linux 2.4.24; i386;)",
				"MSIE (MSIE 6.0; X11; Linux; i686) Opera 7.23",
				"Opera/9.52 (X11; Linux i686; U; en)",
				"Lynx/2.8.5rel.1 libwww-FM/2.14 SSL-MM/1.4.1 GNUTLS/0.8.12",
				"w3m/0.5.1",
				"Links (2.1pre15; FreeBSD 5.3-RELEASE i386; 196x84)",
				"Mozilla/5.0 (X11; U; FreeBSD; i386; en-US; rv:1.7) Gecko",
				"Mozilla/4.77 [en] (X11; I; IRIX;64 6.5 IP30)",
				"Mozilla/4.8 [en] (X11; U; SunOS; 5.7 sun4u)",
				"Mozilla/3.0 (compatible; NetPositive/2.1.1; BeOS)",
				"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
				"Googlebot/2.1 (+http://www.googlebot.com/bot.html)",
				"msnbot/1.0 (+http://search.msn.com/msnbot.htm)",
				"msnbot/0.11 (+http://search.msn.com/msnbot.htm)",
				"Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)",
				"Mozilla/2.0 (compatible; Ask Jeeves/Teoma)",
				"Mozilla/5.0 (compatible; ScoutJet; +http://www.scoutjet.com/)",
				"Gulper Web Bot 0.2.4 (www.ecsl.cs.sunysb.edu/~maxim/cgi-bin/Link/GulperBot)"
			]
		end
	end

	end
end