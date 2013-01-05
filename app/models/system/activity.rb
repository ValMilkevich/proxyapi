class System::Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUSES = [:started, :completed]

  field :name
  field :status, type: String, default: STATUSES.first
  field :exceptions, type: Array, default: nil

  scope :started, where(:status => "started").desc(:created_at)
  scope :completed, where(:status => "completed").desc(:updated_at)

  def complete!
    update_attributes status: STATUSES.last
  end

  STATUSES.each do |status_name|
    define_method "#{status_name}?" do
      self.status.to_sym == status_name.to_sym
    end
  end

  def duration
  	(started? ? Time.now : updated_at) -  created_at
  end
  def human_duration
  	if duration >= 60
	    "#{(duration / 60.0).round(2)} mins"
	  else
	    "#{duration.round(1)} secs"
	  end
  end
end