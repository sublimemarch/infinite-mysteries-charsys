class AddStatusFieldToCharacters < ActiveRecord::Migration
  def change
  	add_column :characters, :status, :integer, default: 0
  end
end
