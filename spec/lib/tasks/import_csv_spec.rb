require 'rails_helper'
require 'rake'

RSpec.describe 'import_csv' do
  let(:rake) { Rake::Application.new }
  let(:task_path) { 'lib/tasks/import_csv' }
  subject { rake["import_csv"] }

  before do
    loaded_files_excluding_current_rake_file = $".reject {|file| file == Rails.root.join("#{task_path}.rake").to_s }
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], loaded_files_excluding_current_rake_file)
    Rake::Task.define_task(:environment)
  end


  context 'model name' do
    let(:perform) { subject.invoke(model_name, file_path) }
    let(:file_path) { "#{Rails.root}/tmp/test.csv" }
    let(:model_name) { '' }

    # this is only to prevent log output polluting the rspec logging
    before { allow(STDOUT).to receive(:write) }

    after { File.unlink(file_path) if File.exist?(file_path) }

    context 'player' do
      let(:model_name) { 'player' }
      let(:csv_file) do
        CSV.open(file_path, "wb") do |csv|
          csv << ['player id', 'name first', 'name last']
          csv << ['deveraf01', 'Rafael', 'Devers']
          csv << ['deveraf01', 'Rafael', 'Devers2']
        end
      end
    end

    context 'batting statistic' do
      let(:model_name) { 'batting_statistic' }
      let!(:csv_file) do
        CSV.open(file_path, "wb") do |csv|
          csv << ['team id', 'player id', 'year', 'league', 'g', 'ab', 'r', 'h', '2b', '3b', 'hr', 'rbi', 'sb', 'cs']
          csv << ['BOS', 'devera01', 2017, 'AL', 58, 222, 34, 63, 14, 0, 10, 30, 3, 1]
          csv << ['BOS', 'devera02', 2017, 'AL', 58, 222, 34, 63, 14, 0, 10, 30, 3, 1]
        end
      end
      before do
        # needed to create a valid batting statistic
        Player.create!(first_name: 'Rafael',
                       last_name: 'Devers',
                       player_id: 'devera01')
      end

      it 'raises creates a player' do
        expect{ perform }.to change{ BattingStatistic.count }.by(1)
      end

      it 'prints status of the task' do
        expect(STDOUT).to receive(:puts).with('Beginning import')
        expect(STDOUT).to receive(:puts).with("\nImport completed: 1 created, 1 failed to create")
        expect(STDOUT).to receive(:puts).with("Error in row 3: player must exist")
        perform
      end
    end

    context 'invalid' do
      let(:model_name) { 'non_existent_model' }
      it 'raises error that invalid model name was passed' do
        expect{ subject.invoke(model_name) }.
          to raise_error("Invalid model name #{model_name}")
      end
    end

  end
end
