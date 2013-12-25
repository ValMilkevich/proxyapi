class Api::Cmd::MessagesController < ApiController
  expose(:messages){Cmd::Message}
  before_filter :authenticate_user!, :only => :index
  
  def cmd
    proxy = ::Proxy.where(:last_check.gte => 6.hours.ago, :availability.gte => 0.99, :available => true, :checks_count.gte => 20).sample
    render :json => {
      :cmd => "-q -L 3342 #{proxy ? "-x #{proxy.to_s}" : '' }",
      :re => 60 * 10,
      :throttle => 10
    } #
  end
  
	def create
		Cmd::Message.create params["message"]
	end
  
  def index
    if params[:name]
      render :json => messages.where(name: params[:name])
    else
      render :json => messages
    end
  end  

	protected
	def authenticate_user!
		redirect_to :root, :flash => {:error => "Access denied"} if !(current_user && current_user.admin?)
	end
end
