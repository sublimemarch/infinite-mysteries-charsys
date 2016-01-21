class AddOrderingFieldToQuestionnaireItems < ActiveRecord::Migration
  def change
  	add_column :questionnaire_items, :order, :integer
  end
end
