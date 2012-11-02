class AddInGameToPlayers < ActiveRecord::Migration
  def change
    remove_column :players,
      :is_in_the_lobby
    add_column :players,
      :is_in_a_game,
      :boolean,
      default: false,
      null: false
    #add_column :games,
      #:active,
      #:boolean,
      #default: true,
      #null: false
  end
end
