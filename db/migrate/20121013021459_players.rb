class Players < ActiveRecord::Migration
  def up
    create_table :players do |t|
      t.string :name,
        null: false
      t.text :deck
      t.text :hand
      t.integer :shield_strength,
        default: 10
      t.integer :ship_strength,
        default: 24
      t.integer :commanders,
        default: 2
      t.integer :weapons,
        default: 5
      t.integer :engineers,
        default: 2
      t.integer :energy,
        default: 5
      t.integer :scientists,
        default: 2
      t.integer :tech,
        default: 5
      t.timestamps
    end
  end

  def down
    drop_table :players
  end
end
