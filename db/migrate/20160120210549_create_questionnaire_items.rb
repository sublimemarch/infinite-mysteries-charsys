class CreateQuestionnaireItems < ActiveRecord::Migration
  def change
    create_table :questionnaire_items do |t|
      t.integer  "campaign_id"
      t.string   "question"
      t.integer  "order"

      t.timestamps null: false
    end
  end
end
