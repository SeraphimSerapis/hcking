class Event < ActiveRecord::Base
  before_save :schedule_to_yaml

  def self.find_in_range(start_date, end_date)
    events = []
    Event.all.each do |event|
      events << event if event.schedule.occurrences_between(start_date, end_date).size > 0
    end
    events
  end

  def schedule
    if @schedule.nil?
      if !self.schedule_yaml.blank?
        @schedule = IceCube::Schedule.from_yaml(self.schedule_yaml)
      else
        @schedule = IceCube::Schedule.new(Time.now)
      end
    end
    @schedule
  end

  def schedule=(cube_obj)
    @schedule = cube_ojb
    self.schedule_yaml = cube_obj.to_yaml
  end

  private

  def schedule_to_yaml
    self.schedule_yaml = self.schedule.to_yaml
  end

end