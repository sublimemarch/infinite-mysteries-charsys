class CharactersController < ApplicationController
	def index

	end

	def show

	end

	def new

	end

	def create

	end

	def edit

	end

	def update

	end

	def destroy

	end

	def validate_stats
		@character = Character.find(params[:id])
		tier1 = @character.powers.where({tier: 1}).count * 3
		tier2 = @character.powers.where({tier: 2}).count * 5
		backgrounds = (@character.item + @character.money + @character.allies - 2, 0).min
		knacks = (@character.knacks.length - 3, 0).min
		respond_to do |format|
			format.json {
				render json: {build_points: tier1 + tier2 + backgrounds + knacks, knacks_ok: knacks >= 3, backgrounds_ok: backgrounds >= 2}
			}
		end
	end

	private

	def character_params

	end
end
