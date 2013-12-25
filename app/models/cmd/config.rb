class Cmd::Config
  include Mongoid::Document
  
  field :cmd, type: String
  field :re, type: String
  field :throttle, type: String
  field :logfile, type: String
  
  # 
  # {
  #   :cmd => "-q -L 3342 #{proxy ? "-x #{proxy.to_s}" : '' }",
  #   :re => 60 * 10,
  #   :throttle => 10
  # }
  # 
  
  def proxy 
    ::Proxy.first
  end
  
  def cmd    
    "-q -L 3342 #{proxy ? "-x #{proxy.to_s}" : '' }"
  end
end
