class Campaign < ActiveRecord::Base
	has_many :user_administers_campaigns
	has_many :users, through: :user_administers_campaigns
end
