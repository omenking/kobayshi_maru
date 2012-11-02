class ChangePlayerDeckHandStuff < ActiveRecord::Migration
  def up
    remove_column :players,
      :hand
    remove_column :players,
      :deck
    add_column :players,
      :deck_card_ids,
      :text
    add_column :players,
      :game_id,
      :integer
    add_column :games,
      :last_move_player_id,
      :integer
  end

  def down
    add_column :players,
      :hand,
      :text
    add_column :players,
      :deck,
      :text
    remove_column :players,
      :hand_card_ids
    remove_column :players,
      :game_id
    remove_column :players,
      :deck_card_ids
    remove_column :games,
      :last_move_player_id
  end
end
