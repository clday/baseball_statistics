class CreateBattingStatistics < ActiveRecord::Migration[5.1]
  def change
    create_table :batting_statistics do |t|
      t.string :team_id, null: false
      t.string :player_id, null: false
      t.integer :year, null: false
      t.string :league, null: false
      t.integer :games, null: false
      t.integer :at_bats, null: false
      t.integer :runs, null: false
      t.integer :hits, null: false
      t.integer :doubles, null: false
      t.integer :triples, null: false
      t.integer :home_runs, null: false
      t.integer :runs_batted_in, null: false
      t.integer :stolen_bases, null: false
      t.integer :caught_stealing, null: false
      t.decimal :batting_average, null: false, precision: 4, scale: 3
      t.decimal :slugging_percentage, null: false, precision: 4, scale: 3

      t.timestamps
    end

    add_index :batting_statistics, :batting_average
    add_index :batting_statistics, :slugging_percentage
    add_index :batting_statistics, :player_id
    add_index :batting_statistics, :team_id
    add_index :batting_statistics, :year
    add_index :batting_statistics, :league
    add_foreign_key :batting_statistics, :players, primary_key: :player_id,
                    on_delete: :cascade
  end
end
