class CreateCharacterHasPowers < ActiveRecord::Migration
  def change
    create_table :character_has_powers do |t|
      t.integer :character_id
      t.integer :power_id
      t.string :specification

      t.timestamps null: false
    end
  end
end
