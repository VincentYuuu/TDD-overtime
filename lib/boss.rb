class Boss
  attr_reader :worker, :overtimechecker

  def assign(worker)
    worker.work!
    @worker = worker
  end

  def start_count(overtimechecker)
    overtimechecker.start_calc!
    @overtimechecker = overtimechecker
  end

  def pay
    overtime_scale = ((overtimechecker.total_overtime / (60.0 * 60)) * 2).floor / 2.0

    case overtime_scale
    when 0..2
      (worker.wage * overtime_scale * 1.34).ceil
    when 2..4
      ((worker.wage * 2 * 1.34) + (worker.wage * (overtime_scale - 2) * 1.67)).ceil
    end
  end
end