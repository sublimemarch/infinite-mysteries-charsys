class CreateUserAdministersCampaigns < ActiveRecord::Migration
  def change
    create_table :user_administers_campaigns do |t|
      t.integer :user_id
      t.integer :campaign_id

      t.timestamps null: false
    end
  end
end
