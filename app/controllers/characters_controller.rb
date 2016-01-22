require 'json'

class CharactersController < ApplicationController
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
		@character = Character.new
	end

	def create
		@character = Character.new(character_params)
		@knacks = params[:character][:knacks]
		@flaws = params[:character][:flaws]
		@character_has_powers = params[:character][:character_has_powers]
		if @character.save!
			@knacks.each do |knack|
				@knack = Knack.new({knack: knack[:knack], character_id: @character.id})
			end
			@flaws.each do |flaw|
				@flaw = Flaw.new({flaw: flaw[:flaw], character_id: @character.id})
			end
			@character_has_powers.each do |power|
				@power = CharacterHasPower.new({character_id: @character.id, power_id: power[:id]})
			end
			flash[:success] = "Your character sheet was saved successfully."
			redirect_to characters_path
		else
			flash[:error] = "There was an error saving your character sheet."
			redirect_to new_character_path
		end
	end

	def edit
		@character = Character.find(params[:id])
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
				unless knack[:id].present?
					@knack = Knack.new({knack: knack[:knack], character_id: @character.id})
					knack_ids << @knack.id
				else
					knack_ids << knack[:id]
				end
			end
			@flaws.each do |flaw|
				unless flaw[:id].present?
					@flaw = Flaw.new({flaw: flaw[:flaw], character_id: @character.id})
					flaw_ids << flaw[:id]
				else
					flaw_ids << flaw[:id]
				end
			end
			@character_has_powers.each do |power|
				unless power[:id].present?
					@power = CharacterHasPower.new({character_id: @character.id, power_id: power[:id]})
					power_ids << @power.id
				else
					power_ids << power[:id]
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
			redirect_to characters_path
		else
			flash[:error] = "There was an error saving your character sheet."
			redirect_to edit_character_path(@character)
		end
	end

	def destroy
		@character = Character.find(params[:id])
		@character.delete
		redirect_to characters_path
	end

	def get_power
		@power = Power.find(params[:id])
		render json: {name: @power.name, description: @power.description, requires_specification: @power.requires_specification, specification_name: @power.specification_name, tier: @power.tier, select_multiple: @power.select_multiple, select_max: @power.select_max}
	end

	private

	def character_params
		params.require(:character).permit(:id, :user_id, :name, :broad_type_id, :campaign_id, :status, :role, :approach, :spirit_max, :spirit_refresh, :regeneration_style, :item, :money, :allies, :item_description, :money_description, :allies_description, :stress_max)
	end
end
