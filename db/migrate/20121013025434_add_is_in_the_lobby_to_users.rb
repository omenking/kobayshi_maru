class AddIsInTheLobbyToUsers < ActiveRecord::Migration
  def change
    add_column :players,
      :is_in_the_lobby,
      :boolean,
      default: false
  end
end
