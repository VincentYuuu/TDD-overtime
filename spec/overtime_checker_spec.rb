require 'boss'
require 'worker'
require 'overtime_checker'
require 'timecop'

RSpec.describe OvertimeChecker do
  let(:boss) { Boss.new }
  let(:worker) { Worker.new(24000) }

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
       expect(boss.pay).to eq(0) # 不予計算加班費
    end

    it '加班第1小時至第2小時，每小時平均工資*時數*1.34' do
      # Act
      Timecop.travel(100 * 60) # 加班 100 分鐘 = 1 小時 40 分鐘
      worker.work_done(overtimechecker)
      
      # Assert
      expect(boss.pay).to eq(201) # 加班費以 1 小時 30 分鐘計算 =  * 
    end

    it '加班第3小時至第4小時，每小時平均工資*時數*1.67' do
      # Act
      Timecop.travel(220 * 60) # 加班 220 分鐘 = 3 小時 40 分鐘
      worker.work_done(overtimechecker)

      # Assert
      expect(boss.pay).to eq(519) # 加班費以 3 小時 30 分鐘計算
    end
  end

  context '休息日的加班	' do
    let(:overtimechecker) { OvertimeChecker.new('dayoff') }

    it '加班第1小時至第2小時，每小時平均工資*時數*1.34' do
      # Act
      Timecop.travel(50 * 60) # 加班 50 分鐘
      worker.work_done(overtimechecker)

      # Assert
      expect(boss.pay).to eq(67) # 加班費以 30 分鐘計算
    end

    it '加班第3小時至第8小時，每小時平均工資*時數*1.67' do
      # Act
      Timecop.travel(370 * 60) # 加班 370 分鐘 = 6 小時 10 分鐘
      worker.work_done(overtimechecker)

      # Assert
      expect(boss.pay).to eq(936) # 加班費以 6 小時計算
    end

    it '加班第9小時至第12小時，每小時平均工資*時數*2.67' do
      Timecop.travel(670 * 60) # 加班 670 分鐘 = 11 小時 10 分鐘
      worker.work_done(overtimechecker)

      # Assert
      expect(boss.pay).to eq(2071) # 加班費以 11 小時計算
    end
  end

  context '休假日的加班' do
    let(:overtimechecker) { OvertimeChecker.new('vacation') }
  
    it '加班第1小時至第8小時，不論加班多久均加給一日工資' do
      Timecop.travel(3 * 60) # 加班 3 分鐘
      worker.work_done(overtimechecker)

      # Assert
      expect(boss.pay).to eq(800) # 加班費以 1 日工資計算
    end

    it '加班第9小時至第10小時	，每小時平均工資*時數*2.34' do
      Timecop.travel(575 * 60) # 加班 575 分鐘 = 9 小時 35 分鐘
      worker.work_done(overtimechecker)

      # Assert
      expect(boss.pay).to eq(1151) # 加班費以 9 小時 30 分鐘計算
    end

    it '加班第11小時至第12小時，每小時平均工資*時數*2.67' do
      Timecop.travel(635 * 60) # 加班 635 分鐘 = 10 小時 35 分鐘
      worker.work_done(overtimechecker)

      # Assert
      expect(boss.pay).to eq(1402) # 加班費以 10 小時 30 分鐘計算
    end
  end

  context '休假日的加班' do
    let(:overtimechecker) { OvertimeChecker.new('vacation_and_special_condition') }

    it '加班第1小時至第8小時，每小時平均工資*時數*2' do
      Timecop.travel(400 * 60) # 加班 400 分鐘 = 6 小時 40 分鐘
      worker.work_done(overtimechecker)

      # Assert
      expect(boss.pay).to eq(1300) # 加班費以 6 小時 30 分鐘計算
    end

    it '加班第9小時至第10小時	，每小時平均工資*時數*2.34' do
      Timecop.travel(575 * 60) # 加班 575 分鐘 = 9 小時 35 分鐘
      worker.work_done(overtimechecker)

      # Assert
      expect(boss.pay).to eq(1951) # 加班費以 9 小時 30 分鐘計算
    end

    it '加班第11小時至第12小時，每小時平均工資*時數*2.67' do
      Timecop.travel(635 * 60) # 加班 635 分鐘 = 10 小時 35 分鐘
      worker.work_done(overtimechecker)

      # Assert
      expect(boss.pay).to eq(2202) # 加班費以 10 小時 30 分鐘計算
    end
  end
end