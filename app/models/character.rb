class Character < ActiveRecord::Base
	belongs_to :broad_type
	belongs_to :campaign
	belongs_to :user
	has_many :character_has_powers
	has_many :powers, through: :character_has_powers
	has_many :knacks
	has_many :flaws
	has_many :questionnaire_answers
	belongs_to :approach

	accepts_nested_attributes_for :knacks, :flaws, :character_has_powers
end
