class CharactersController < ApplicationController
	before_action :authenticate_user!
	
	def index
		@characters = Character.find_by_user_id(current_user)
	end

	def show
		@character = Character.find(params[:id])
	end

	def new
		@character = Character.new
	end

	def create
		@character = Character.new(character_params)
		if @character.save!
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
		@character = Character.find(params[:character][:id])
		if @character.update_attributes!(character_params)
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

	private

	def character_params
		params.require(:character).permit(:id, :user_id, :name, :broad_type_id, :role, :approach, :spirit_max, :spirit_refresh, :regeneration_style, :character_has_powers, :item, :money, :allies, :item_description, :money_description, :allies_description, :knacks, :flaws, :stress_max)
	end
end
