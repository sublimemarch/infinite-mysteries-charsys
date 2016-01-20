class CreateQuestionnaireAnswers < ActiveRecord::Migration
  def change
    create_table :questionnaire_answers do |t|
      t.integer :character_id
      t.integer :questionnaire_item_id
      t.text :answer

      t.timestamps null: false
    end
  end
end
