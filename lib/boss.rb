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

    case overtimechecker.day_type
    when 'workday'
      case overtime_scale
      when 0..2
        (salary_per_hour * overtime_scale * 1.34).ceil
      when 2..4
        ((salary_per_hour * 2 * 1.34) + (salary_per_hour * (overtime_scale - 2) * 1.67)).ceil
      end
    when 'dayoff'
      case overtime_scale
      when 0..2
        (salary_per_hour * overtime_scale * 1.34).ceil
      when 2..8
        ((salary_per_hour * 2 * 1.34) + (salary_per_hour * (overtime_scale - 2) * 1.67)).ceil
      when 8..12
        ((salary_per_hour * 2 * 1.34) + (salary_per_hour * 6 * 1.67) + (salary_per_hour * (overtime_scale - 8) * 2.67)).ceil
      end
    end
  end

  private
  def salary_per_hour
    worker.salary / 30 / 8
  end

end