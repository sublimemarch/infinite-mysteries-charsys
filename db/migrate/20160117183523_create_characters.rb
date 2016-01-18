class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.integer :user_id
      t.string :name
      t.integer :broad_type
      t.string :role
      t.integer :approach
      t.integer :spirit_max
      t.integer :spirit_refresh
      t.string :regeneration_style
      t.integer :item
      t.integer :money
      t.integer :allies
      t.text :item_description
      t.text :money_description
      t.text :allies_description
      t.integer :stress_max

      t.timestamps null: false
    end
  end
end
