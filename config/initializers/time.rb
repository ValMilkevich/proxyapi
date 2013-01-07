class Time
  def round(seconds = 60)
    self.class.zone.at((self.to_f / seconds).round * seconds)
  end

  def floor(seconds = 60)
    self.class.zone.at((self.to_f / seconds).floor * seconds)
  end
end