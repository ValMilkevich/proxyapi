class Api::Cmd::MessagesController < ApiController
  before_filter :authenticate_user!, :only => :index
  
  def cmd
    # JSON.load(open("http://proxyapi.info/api/proxies/selector/last_check(#{6.hours.ago.strftime('%Y%m%d%H%M')}-202012010000):order(latency.desc):availability(1,0-0.99):available(true):checks_count(10-10000000).json")).sample
    render :json => {:cmd => "-q -L 3342"} #
  end
  
	def create
		Cmd::Message.create params["message"]
	end
  
  def index
    render :json => Cmd::Message.all
  end  

	protected
	def authenticate_user!
		redirect_to :root, :flash => {:error => "Access denied"} if !(current_user && current_user.admin?)
	end
end
