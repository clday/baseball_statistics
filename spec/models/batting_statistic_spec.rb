require 'rails_helper'

RSpec.describe BattingStatistic do
  let(:player) do
    Player.create!(first_name: 'Rafael',
                   last_name: 'Devers',
                   player_id: 'devera01')
  end
  subject do
    described_class.new(team_id: 'BOS',
                        player: player,
                        year: 2017,
                        league: 'AL',
                        games: 58,
                        at_bats: 222,
                        runs: 34,
                        hits: 63,
                        doubles: 14,
                        triples: 0,
                        home_runs: 10,
                        runs_batted_in: 30,
                        stolen_bases: 3,
                        caught_stealing: 1)
  end

  describe '#batting_average' do
    it 'sets batting_average before persisting' do
      expect{ subject.save! }.to change{ subject.batting_average }.
        from(nil).to(0.284)
    end
  end

  describe '#slugging_percentage' do
    it 'sets slugging_percentage before persisting' do
      expect{ subject.save! }.to change{ subject.slugging_percentage}.
        from(nil).to(0.482)
    end
  end
end
