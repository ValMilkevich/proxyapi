class Api::Cmd::ProcsController < ApiController
	
  def cmd
    # JSON.load(open("http://proxyapi.info/api/proxies/selector/last_check(#{6.hours.ago.strftime('%Y%m%d%H%M')}-202012010000):order(latency.desc):availability(1,0-0.99):available(true):checks_count(10-10000000).json")).sample
    render :json => {:cmd => "-q"}
  end
  
	def index
		
	end
end
