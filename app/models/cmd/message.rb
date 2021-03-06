class Cmd::Message
  include Mongoid::Document
	include Mongoid::Timestamps
  
  field :body, type: String
  field :name, type: String
  field :proc_status, type: String

  before_save :format_body

  def self.by_hour( from = 1.month.ago)
    Cmd::Message.where(:created_at.gte => from ).group_by{|m| m.created_at.strftime('%Y-%m-%d %H:00') }
  end
  
  def self.khash_by_hour( from = 1.month.ago)
    res = {}
    by_hour(from).each do |date, arr|
      res[date] = arr.sum{|a| a.body.scan(/([\d]+\.[\d]+) khash\/s/).flatten.first.to_f}
    end
    res
  end
  
  def format_body
    self.body = self.body.gsub(/\u0000/, '')
  end
  
end

 # 
 # kh = Cmd::Message.all.group_by(&:name).map{|n, a| {n => a.inject({}){|res, e| l = e.body.scan(/thread ([\d]+):.*([\d]+\.[\d]+) khash\/s/).flatten; res[l.first] ||= []; res[l.first] << l.second.to_f; res} } }.map{|h| h.map{|k,v| v.map{|d,c| c.sum / c.size}}}.flatten.sum