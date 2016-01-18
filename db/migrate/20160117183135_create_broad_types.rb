class CreateBroadTypes < ActiveRecord::Migration
  def change
    create_table :broad_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
