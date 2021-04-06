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
    end
  end
end