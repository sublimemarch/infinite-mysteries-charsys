class CreatePowers < ActiveRecord::Migration
  def change
    create_table :powers do |t|
      t.string :name
      t.integer :tier
      t.text :description

      t.timestamps null: false
    end
  end
end
