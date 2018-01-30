class ImportBattingStatisticCSV
  include CSVImporter

  model BattingStatistic

  column :team_id, as: [/team.?id/i], required: true
  column :player_id, as: [/player.?id/i], required: true
  column :year, as: [/year.?id/i, "year"], required: true
  column :league, as: [/league/i], required: true
  column :games, as: ["g", "games"], required: true
  column :at_bats, as: [/at.?bats/i, "ab"], required: true
  column :runs, as: ["runs", "r"], required: true
  column :hits, as: ["hits", "h"], required: true
  column :doubles, as: ["2b", "doubles"], required: true
  column :triples, as: ["3b", "triples"], required: true
  column :home_runs, as: ["hr", /home.?runs/i], required: true
  column :runs_batted_in, as: [/runs.?batted.?in/i, "rbi"], required: true
  column :stolen_bases, as: [/stolen.?bases/i, "sb"], required: true
  column :caught_stealing, as: [/caught.?stealing/i, "cs"], required: true
end
