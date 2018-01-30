require 'rails_helper'

RSpec.describe ImportBattingStatisticCSV do
  subject { described_class.new(content: csv) }
  let(:csv) do
    [
      ['team id', 'player id', 'year', 'league', 'g', 'ab', 'r', 'h', '2b', '3b', 'hr', 'rbi', 'sb', 'cs'],
      ['BOS', 'devera01', 2017, 'AL', 58, 222, 34, 63, 14, 0, 10, 30, 3, 1],
      ['BOS', 'devera02', 2017, 'AL', 58, 222, 34, 63, 14, 0, 10, 30, 3, 1],
      ['BOS', 'devera01', 2017, nil, 58, 222, 34, 63, 14, 0, 10, 30, 3, 1],
      ['BOS', 'devera01', 2017, 'AL', 58, 222, 34, 63, 14, 0, 10, nil, 3, 1,],
    ].map { |row| row.join(",") }
     .join("\n")
  end

  before do
    Player.create!(first_name: 'Rafael',
                   last_name: 'Devers',
                   player_id: 'devera01')
  end

  describe '#run!' do
    it 'creates a batting_statistic' do
      expect{ subject.run! }.to change{ BattingStatistic.count }.from(0).to(1)
    end

    let(:invalid_rows) { subject.report.invalid_rows }

    it 'logs unknown player in row 3' do
      subject.run!
      row_three = invalid_rows.find { |row| row.line_number == 3 }
      expect(row_three.errors).to eq({:player=>"must exist"})
    end

    it 'logs missing requirements in rows 4 and 5' do
      subject.run!
      row_four = invalid_rows.find { |row| row.line_number == 4 }
      row_five = invalid_rows.find { |row| row.line_number == 5 }

      expect(row_four.errors).to eq({"league"=>"can't be blank"})
      expect(row_five.errors).to eq({"rbi"=>"can't be blank"})
    end
  end
end
