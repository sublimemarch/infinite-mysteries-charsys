class QuestionnaireAnswer < ActiveRecord::Base
	belongs_to :character
	belongs_to :questionnaire_item
end
