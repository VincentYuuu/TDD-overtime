class Worker
  attr_reader :wage, :overtimechecker

  def initialize(wage)
    @wage = wage
  end

  def work!
  end

  def work_done(overtimechecker)
    overtimechecker.end_calc!
    @overtimechecker = overtimechecker
  end
end