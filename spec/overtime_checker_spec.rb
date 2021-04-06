require 'boss'
require 'worker'
require 'overtime_checker'
require 'timecop'

RSpec.describe OvertimeChecker do
  let(:boss) { Boss.new }
  let(:worker) { Worker.new(160) }

  before(:example) do
    boss.assign(worker)
    boss.start_count(overtimechecker)
  end

  context '平日的加班（含平日時因天災、事變或突發事件的加班）' do
    let(:overtimechecker) { OvertimeChecker.new('workday') }

    it '加班時數不滿 30 分鐘不予計算' do
       # Act
       Timecop.travel(20 * 60) # 加班 20 分鐘，不滿 30 分鐘
       worker.work_done(overtimechecker)
       
       # Assert
       expect(boss.pay).to eq(0) # 加班費以 1 小時 30 分鐘計算
    end

    it '加班第1小時至第2小時，每小時平均工資*時數*1.34' do
      # Act
      Timecop.travel(100 * 60) # 加班 100 分鐘 = 1 小時 40 分鐘
      worker.work_done(overtimechecker)
      
      # Assert
      expect(boss.pay).to eq(322) # 加班費以 1 小時 30 分鐘計算
    end

    it '加班第3小時至第4小時，每小時平均工資*時數*1.67' do
      # Act
      Timecop.travel(220 * 60) # 加班 220 分鐘 = 3 小時 40 分鐘
      worker.work_done(overtimechecker)

      # Assert
      expect(boss.pay).to eq(830) # 加班費以 3 小時 30 分鐘計算
    end
  end
end