class CreatePowers < ActiveRecord::Migration
  def change
    create_table :powers do |t|
      t.string   "name"
      t.integer  "tier"
      t.text     "description"
      t.boolean  "requires_specification", default: false
      t.string   "specification_name",     default: ""
      t.boolean  "select_multiple",        default: false
      t.integer  "select_max",             default: 0

      t.timestamps null: false
    end
  end
end
