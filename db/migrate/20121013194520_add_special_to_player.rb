class AddSpecialToPlayer < ActiveRecord::Migration
  def change
    add_column :players,
      :special,
      :text,
      null: false,
      default: ''
  end
end
