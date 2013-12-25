class Admin::MinersController < AdminController
  
  def show
    @miners = Cmd::Message.where(name: params[:id]).sort('created_at desc')
  end
end
