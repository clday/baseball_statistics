class BattingStatistic < ApplicationRecord
  validates :team_id, :player, :year, :league, :games, :at_bats, :runs,
            :hits, :doubles, :triples, :home_runs, :runs_batted_in,
            :stolen_bases, :caught_stealing, :slugging_percentage,
            :batting_average, presence: true

  belongs_to :player, primary_key: 'player_id'

  before_validation :update_batting_average
  before_validation :update_slugging_percentage

  private
  # these columns are denormalized calculations so we always want to run the
  # calculations before persisting
  def update_batting_average
    self.batting_average = (at_bats.to_i == 0 ? 0 : BigDecimal.new(hits) / at_bats)
  end

  def update_slugging_percentage
    self.slugging_percentage = (at_bats.to_i == 0 ? 0 : BigDecimal.new(total_bases) / at_bats)
  end

  def total_bases
    hits.to_i + doubles.to_i + (2 * triples.to_i) + (3 * home_runs.to_i)
  end
end
