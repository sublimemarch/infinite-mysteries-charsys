class QuestionnaireItem < ActiveRecord::Base
	belongs_to :campaign
	has_many :questionnaire_answers
end
