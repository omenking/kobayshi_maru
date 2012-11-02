class AddGames < ActiveRecord::Migration
  def up
    create_table :games do |t|
      t.integer :player_1_id
      t.integer :player_2_id
      t.timestamps
    end
  end

  def down
    drop_table :games
  end
end
