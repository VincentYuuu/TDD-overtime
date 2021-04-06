class Worker
  attr_reader :salary, :overtimechecker

  def initialize(salary)
    @salary = salary
  end

  def work!
  end

  def work_done(overtimechecker)
    overtimechecker.end_calc!
    @overtimechecker = overtimechecker
  end
end