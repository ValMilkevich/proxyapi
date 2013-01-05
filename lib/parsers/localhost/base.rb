module Parsers::Localhost
  class Base
    include Parsers::Base

    EXAMPLE_HEADER = {
      "GATEWAY_INTERFACE"=>"CGI/1.1",
      "PATH_INFO"=>"/api/test",
      "QUERY_STRING"=>"",
      "REMOTE_ADDR"=>"127.0.0.1",
      "REMOTE_HOST"=>"localhost",
      "REQUEST_METHOD"=>"GET",
      "REQUEST_URI"=>"http://localhost:3000/api/test",
      "SCRIPT_NAME"=>"",
      "SERVER_NAME"=>"localhost",
      "SERVER_PORT"=>"3000",
      "SERVER_PROTOCOL"=>"HTTP/1.1",
      "SERVER_SOFTWARE"=>"WEBrick/1.3.1 (Ruby/1.9.3/2012-11-10)",
      "HTTP_HOST"=>"localhost:3000",
      "HTTP_CONNECTION"=>"keep-alive",
      "HTTP_CACHE_CONTROL"=>"max-age=0",
      "HTTP_USER_AGENT"=>
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.101 Safari/537.11",
      "HTTP_ACCEPT"=>
      "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      "HTTP_ACCEPT_ENCODING"=>"gzip,deflate,sdch",
      "HTTP_ACCEPT_LANGUAGE"=>"en-US,en;q=0.8",
      "HTTP_ACCEPT_CHARSET"=>"ISO-8859-1,utf-8;q=0.7,*;q=0.3",
      "HTTP_COOKIE"=>
      "Locations_filter=20&38&32&6&7&3&67&40&4&5&58&57&11; hidden_announcement_ids=3&11%2613%2612%2610%268%266%267%266%265%2614%264%261%26; _session_id=BAh7CEkiD3Nlc3Npb25faWQGOgZFRkkiJWI0N2QwYjNkMTI5YTJmMDg4NGJkMTgzOTJhZDgyOTZiBjsAVEkiEF9jc3JmX3Rva2VuBjsARkkiMTRqbWgrclc2UFdBUUJpYStkbWVseHNaN3RTc1ZJb0swYStOcitZNFo1Mms9BjsARkkiGXdhcmRlbi51c2VyLnVzZXIua2V5BjsAVFsISSIJVXNlcgY7AEZbBlU6Gk1vcGVkOjpCU09OOjpPYmplY3RJZCIRUOhrRCkraMQ6AAAGSSIiJDJhJDEwJHc1RHVEa2lXUkNQZVB3ZlNPY2QzenUGOwBU--66aecd88f581efcc15f0479c2b2ada8e3e54f7b8",
      "HTTP_IF_NONE_MATCH"=>"9e43b1bfafee8f434eaa59d065212a2a",
      "HTTP_VERSION"=>"HTTP/1.1",
      "REQUEST_PATH"=>"/api/test",
      "ORIGINAL_FULLPATH"=>"/api/test"
     }
    cattr_accessor :latency, :headers, :host, :from

    @@latency = 1500
    @@headers = [:ip, :port, :country_name, :city_name, :initial_latency, :type, :anonymity, :check_time, :port_image_url]

    @@host = "http://localhost:3000"
    @@from = "localhost:3000"

    def url
      "http://localhost:3000/api/test"
    end

		def self.headers
      super.merge(
        "Host" => self.from,
        "Referer" => self.host
      )
    end
  end
end

