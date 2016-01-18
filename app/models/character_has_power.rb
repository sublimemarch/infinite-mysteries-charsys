class CharacterHasPower < ActiveRecord::Base
	belongs_to :character
	belongs_to :power
end
