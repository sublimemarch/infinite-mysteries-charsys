require 'json'

class CharactersController < ApplicationController
	T1_COST = 3
	T2_COST = 5
	STANDARD_BACKGROUNDS = 2
	MORTAL_BACKGROUNDS = 4
	WYRD_POWER_POINTS = 3
	UNDEAD_BONUS_KNACKS = 3
	GOODNEIGHBOR_BONUS_KNACKS = 3
	MORTAL_MAX_KNACKS = 5

	CHARACTER_STATUS = ['In Progress', 'Submitted', 'Approved', 'Active', 'Deceased', 'Inactive']
	def get_status(status)
		return CHARACTER_STATUS[status]
	end

	helper_method :get_status

	before_action :authenticate_user!

	def index
		@characters = Character.where(user_id: current_user)
	end

	def show
		@character = Character.find(params[:id])
	end

	def new
		@character = Character.new({campaign_id: 1})
	end

	def create
		@character = Character.new(character_params)
		@knacks = params[:character][:knacks]
		@flaws = params[:character][:flaws]
		@character_has_powers = params[:character][:character_has_powers]
		if @character.save!
			@knacks.each do |knack|
				if knack[:knack].present?
					@knack = Knack.new({knack: knack[:knack], character_id: @character.id})
					@knack.save!
				end
			end
			@flaws.each do |flaw|
				if flaw[:flaw].present?
					@flaw = Flaw.new({flaw: flaw[:flaw], character_id: @character.id})
					@flaw.save!
				end
			end
			@character_has_powers.each do |power|
				if power[:power_id].present?
					@power = CharacterHasPower.new({character_id: @character.id, power_id: power[:power_id], specification: power[:specification]})
					@power.save!
				end
			end
			flash[:success] = "Your character sheet was saved successfully."
			redirect_to root_path
		else
			flash[:error] = "There was an error saving your character sheet."
			redirect_to new_character_path
		end
	end

	def edit
		@character = Character.find(params[:id])
		unless (@character.status == 0 and @character.user == current_user) or (@character.campaign.users.include?(current_user))
			redirect_to :root
		end
	end

	def update
		@character = Character.find(params[:id])
		@knacks = params[:character][:knacks]
		@flaws = params[:character][:flaws]
		@character_has_powers = params[:character][:character_has_powers]
		knack_ids = []
		flaw_ids = []
		power_ids = []
		if @character.update_attributes!(character_params)
			@knacks.each do |knack|
				if knack[:knack].present?
					unless knack[:id].present?
						@knack = Knack.new({knack: knack[:knack], character_id: @character.id})
						@knack.save!
						knack_ids << @knack.id
					else
						knack_ids << knack[:id].to_i
					end
				end
			end
			@flaws.each do |flaw|
				if flaw[:flaw].present?
					unless flaw[:id].present?
						@flaw = Flaw.new({flaw: flaw[:flaw], character_id: @character.id})
						@flaw.save!
						flaw_ids << @flaw.id
					else
						flaw_ids << flaw[:id].to_i
					end
				end
			end
			@character_has_powers.each do |power|
				if power[:power_id].present?
					unless power[:id].present?
						@power = CharacterHasPower.new({character_id: @character.id, power_id: power[:power_id], specification: power[:specification]})
						@power.save!
						power_ids << @power.id
					else
						@power = CharacterHasPower.find(power[:id])
						@power.update_attributes!({specification: power[:specification]})
						power_ids << @power.id
					end
				end
			end
			@character.knacks.each do |knack|
				unless knack_ids.include?(knack.id)
					knack.delete
				end
			end
			@character.flaws.each do |flaw|
				unless flaw_ids.include?(flaw.id)
					flaw.delete
				end
			end
			@character.character_has_powers.each do |power|
				unless power_ids.include?(power.id)
					power.delete
				end
			end
			flash[:success] = "Your character sheet was saved successfully."
			redirect_to character_path(@character)
		else
			flash[:error] = "There was an error saving your character sheet."
			redirect_to edit_character_path(@character)
		end
	end

	def destroy
		@character = Character.find(params[:id])
		@character.delete
		redirect_to root_path
	end

	def get_power
		@power = Power.find(params[:id])
		render json: {name: @power.name, description: @power.description, requires_specification: @power.requires_specification, specification_name: @power.specification_name, tier: @power.tier, select_multiple: @power.select_multiple, select_max: @power.select_max}
	end

	def validate_stats
		broad_type = BroadType.find(params[:character][:broad_type_id])
		powers = params[:character][:character_has_powers]
		tier1 = 0
		tier2 = 0;
		powers.each do |power|
			if power[:power_id].present?
				power_rec = Power.find(power[:power_id])
				if power_rec.tier == 1
					tier1 += 1
				else
					tier2 += 1
				end
			end
		end
		power_points = tier1 * T1_COST + tier2 * T2_COST
		if broad_type.name == "Wyrd"
			power_points -= WYRD_POWER_POINTS
		end
		backgrounds = params[:character][:item].to_i + params[:character][:money].to_i + params[:character][:allies].to_i
		if broad_type.name == "Mortal"
			background_points = [backgrounds - MORTAL_BACKGROUNDS, 0].max
		else
			background_points = [backgrounds - STANDARD_BACKGROUNDS, 0].max
		end
		knacks = params[:character][:knacks].delete_if {|knack| knack[:id] == ""}
		knacks = knacks.length
		knack_points = [knacks - 3, 0].min
		if broad_type.name == "Mortal"
			if knacks <= 8 && knacks >= 3
				knacks_ok = true
				knacks_error = 0
			else
				knacks_ok = false
				if knacks > 8
					knacks_error = knacks - 8
				else
					knacks_error = 3 - knacks
				end
			end
		elsif broad_type.name == "Wyrd"
			if knacks <= 3
				knacks_ok = true
				knacks_error = 0
			else
				knacks_ok = false
				knacks_error = knacks - 3
			end
		else
			if knacks <= 6 && knacks >= 3
				knacks_ok = true
				knacks_error = 0
			else
				knacks_ok = false
				if knacks > 6
					knacks_error = knacks - 6
				else
					knacks_error = 3 - knacks
				end
			end
		end
		render json: {build_points: power_points + background_points + knack_points, knacks_ok: knacks_ok, knacks_error: knacks_error, backgrounds_ok: backgrounds >= 2}
	end

	private

	def character_params
		params.require(:character).permit(:id, :user_id, :name, :broad_type_id, :campaign_id, :status, :role, :approach_id, :spirit_max, :spirit_refresh, :regeneration_style, :item, :money, :allies, :item_description, :money_description, :allies_description, :stress_max)
	end
end
