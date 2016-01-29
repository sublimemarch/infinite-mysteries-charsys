class ChangeNameOfBroadTypeColumn < ActiveRecord::Migration
  def change
  	rename_column :characters, :broad_type, :broad_type_id
  end
end
