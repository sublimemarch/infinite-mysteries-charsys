class CreateKnacks < ActiveRecord::Migration
  def change
    create_table :knacks do |t|
      t.integer :character_id
      t.string :knack

      t.timestamps null: false
    end
  end
end
