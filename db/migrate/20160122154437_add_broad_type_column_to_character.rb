class AddBroadTypeColumnToCharacter < ActiveRecord::Migration
  def change
  	add_column :characters, :broad_type_id, :integer
  end
end
