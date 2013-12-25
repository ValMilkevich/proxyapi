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
    ::Proxy.where(:last_check.gte => 6.hours.ago, :availability.gte => 0.99, :available => true, :checks_count.gte => 20).sample
  end
  
  def cmd    
    "-q -L 3342 #{proxy ? "-x #{proxy.to_s}" : '' }"
  end
end
