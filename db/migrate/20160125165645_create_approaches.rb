class CreateApproaches < ActiveRecord::Migration
  def change
    create_table :approaches do |t|
      t.string :name

      t.timestamps null: false
    end

    rename_column :characters, :approach, :approach_id
  end
end
