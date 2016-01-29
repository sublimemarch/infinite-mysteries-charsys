class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   "username"
      t.string   "display_name"
      t.string   "email",                  default: "", null: false
      t.string   "password_digest"
      t.string   "encrypted_password",     default: "", null: false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          default: 0,  null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.inet     "current_sign_in_ip"
      t.inet     "last_sign_in_ip"

      t.timestamps null: false
    end
  end
end
