class Api::Cmd::MessagesController < ApiController
  expose(:messages){Cmd::Message}
  before_filter :authenticate_user!, :only => :index
  
  def cmd    
    render :json => Cmd::Config.last    
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
