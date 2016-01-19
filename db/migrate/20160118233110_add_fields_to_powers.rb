class AddFieldsToPowers < ActiveRecord::Migration
  def change
  	add_column :powers, :requires_specification, :boolean, default: false
  	add_column :powers, :specification_name, :string, default: ''
  	add_column :powers, :select_multiple, :boolean, default: false
  end
end
