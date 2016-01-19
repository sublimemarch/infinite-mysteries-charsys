class AddSelectMaxFieldToPowers < ActiveRecord::Migration
  def change
  	add_column :powers, :select_max, :integer, default: 0
  end
end
