class RemoveBroadTypeColumn < ActiveRecord::Migration
  def change
  	remove_column :characters, :broad_type
  end
end
