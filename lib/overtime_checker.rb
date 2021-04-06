class OvertimeChecker
  attr_reader :day_type, :start_time, :end_time

  def initialize(day_type)
    @day_type = day_type
  end

  def start_calc!
    @start_time = Time.now
    @end_time = nil
  end

  def end_calc!
    @end_time = Time.now
  end

  def total_overtime
    (end_time - start_time).to_i
  end
end