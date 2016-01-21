class Campaign < ActiveRecord::Base
	validates :name, presence: true
	validates :build_points, presence: true
	has_many :user_administers_campaigns
	has_many :users, through: :user_administers_campaigns
	has_many :questionnaire_items

	accepts_nested_attributes_for :user_administers_campaigns
end
