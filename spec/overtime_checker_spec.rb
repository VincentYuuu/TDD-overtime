require 'boss'
require 'worker'
require 'overtime_checker'
require 'timecop'

RSpec.describe OvertimeChecker do
  context '平日的加班（含平日時因天災、事變或突發事件的加班）' do
    it '加班第1小時至第2小時，每小時平均工資*時數*1.34' do
      # Act
      boss.assign(worker)
      boss.start_count(overtimechecker)
      Timecop.travel(100 * 60) # 加班 100 分鐘 = 1 小時 40 分鐘
      worker.work_done(overtime)
      
      # Assert
      expect(boss.pay).to eq(322) # 加班費以 1 小時 30 分鐘計算
    end
  end
end