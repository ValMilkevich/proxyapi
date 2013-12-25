class Cmd::Message
  include Mongoid::Document
	include Mongoid::Timestamps
  
  field :body, type: String
  field :name, type: String
  field :proc_status, type: String
end
