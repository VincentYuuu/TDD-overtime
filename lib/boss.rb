class Boss
  attr_reader :worker, :overtimechecker

  def assign(worker)
    @worker = worker
  end

  def start_count(overtimechecker)
    overtimechecker.start_calc!
    @overtimechecker = overtimechecker
  end

  def pay
    case overtimechecker.day_type
    when 'workday'
      weekday_calc

    when 'dayoff'
      dayoff_calc

    when 'vacation'
      vacation_calc

    when 'vacation_and_special_condition'
      vacation_special_calc

    else
      "YOU CRAZY!!! Workers can't work over 12 hours!!!"
    end
  end

  private
  def salary_per_hour # 平均時薪計算方式
    worker.salary / 30 / 8 # 月薪 / 30 天 / 工作 8 小時
  end

  def overtime_scale
    ((overtimechecker.total_overtime / (60.0 * 60)) * 2).floor / 2.0 

    # 把總工作秒數單位換算成小時，並以 30 分鐘為基準，不滿 30 分鐘無條件捨去
  end

  def weekday_calc # calc overtime pay under weekday context
    case overtime_scale
    when 0..2
      (salary_per_hour * overtime_scale * 1.34).ceil

    when 2..4
      ((salary_per_hour * 2 * 1.34) + (salary_per_hour * (overtime_scale - 2) * 1.67)).ceil
    end
  end

  def dayoff_calc # calc overtime pay under dayoff context
    case overtime_scale
    when 0..2
      (salary_per_hour * overtime_scale * 1.34).ceil
      
    when 2..8
      ((salary_per_hour * 2 * 1.34) + (salary_per_hour * (overtime_scale - 2) * 1.67)).ceil

    when 8..12
      ((salary_per_hour * 2 * 1.34) + (salary_per_hour * 6 * 1.67) + (salary_per_hour * (overtime_scale - 8) * 2.67)).ceil
    end
  end

  def vacation_calc # calc overtime pay under vacation context
    case overtime_scale
    when 0..8
      salary_per_hour * 8

    when 8..10
      (salary_per_hour * 8) + (salary_per_hour * (overtime_scale - 8) * 2.34).ceil

    when 10..12
      (salary_per_hour * 8) + (salary_per_hour * 2 * 2.34) + (salary_per_hour * (overtime_scale - 10) * 2.67).ceil
    end
  end

  def vacation_special_calc # calc overtime pay under vacation_and_special_condition context
    case overtime_scale
    when 0..8
      (salary_per_hour * overtime_scale * 2).ceil

    when 8..10
      (salary_per_hour * 8 * 2) + (salary_per_hour * (overtime_scale - 8) * 2.34).ceil

    when 10..12
      (salary_per_hour * 8 * 2) + (salary_per_hour * 2 * 2.34) + (salary_per_hour * (overtime_scale - 10) * 2.67).ceil
    end
  end
end