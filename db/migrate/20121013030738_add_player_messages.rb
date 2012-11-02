class AddPlayerMessages < ActiveRecord::Migration
  def up
    create_table :player_messages do |t|
      t.integer :player_id
      t.text :message
      t.timestamps
    end
  end

  def down
    drop_table :player_messages
  end
end
