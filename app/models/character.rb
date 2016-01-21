class Character < ActiveRecord::Base
	has_one :broad_type
	has_many :character_has_powers
	has_many :powers, through: :character_has_powers
	has_many :knacks
	has_many :flaws
	has_many :questionnaire_answers

	accepts_nested_attributes_for :knacks, :flaws, :character_has_powers
end
