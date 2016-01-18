class CreateFlaws < ActiveRecord::Migration
  def change
    create_table :flaws do |t|
      t.integer :character_id
      t.string :flaw

      t.timestamps null: false
    end
  end
end
