class AddHandToPlayer < ActiveRecord::Migration
  def change
    add_column :players,
      :hand_card_ids,
      :text
  end
end
