require 'rails_helper'

RSpec.describe ImportPlayerCSV do
  subject { described_class.new(content: csv) }
  let(:csv) do
    [
      ['player id', 'name first', 'name last'],
      ['deveraf01', 'Rafael', 'Devers'],
      ['deveraf01', 'Rafael', 'Devers2'],
      ['deveraf02', nil, 'Devers'],
      ['deveraf02', 'Rafael', nil],
      [nil, 'Rafael', 'Devers']
    ].map { |row| row.join(",") }
     .join("\n")
  end

  describe '#run!' do
    let(:invalid_rows) { subject.report.invalid_rows }
    it 'creates a player' do
      expect{ subject.run! }.to change{ Player.count }.from(0).to(1)
    end

    it 'logs duplicate player_id in row 3' do
      subject.run!
      row_three = invalid_rows.find { |row| row.line_number == 3 }
      expect(row_three.errors).to eq({"player id"=>"has already been taken"})
    end

    it 'logs missing requirements in rows 4,5,6' do
      subject.run!
      row_four = invalid_rows.find { |row| row.line_number == 4 }
      row_five = invalid_rows.find { |row| row.line_number == 5 }
      row_six = invalid_rows.find { |row| row.line_number == 6 }

      expect(row_four.errors).to eq({"name first"=>"can't be blank"})
      expect(row_five.errors).to eq({"name last"=>"can't be blank"})
      expect(row_six.errors).to eq({"player id"=>"can't be blank"})
    end
  end
end
