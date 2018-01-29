class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name, null: false
      t.string :player_id, null: false
      t.integer :birth_year

      t.timestamps
    end

    add_index :players, :player_id, unique: true
  end
end
