class CampaignsController < ApplicationController
	before_action :authenticate_user!
	
	def index
		@campaigns = Campaign.where({user: current_user})
	end
	
	def show
		@campaign = Campaign.find(params[:id])
	end

	def new
		@campaign = Campaign.new
	end

	def create
		@campaign = Campaign.new(campaign_params)
		if @campaign.save!
			flash[:success] = "Your new campaign was successfully saved."
			redirect_to campaign_path(@campaign)
		else
			flash[:error] = "There was an error creating your campaign."
			redirect_to new_campaign_path
		end
	end

	def edit
		@campaign = Campaign.find(params[:id])
	end

	def update
		@campaign = Campaign.find(params[:campaign][:id])
		if @campaign.update_attributes!(campaign_params)
			flash[:success] = "The changes to your campaign were successfully saved."
			redirect_to campaign_path(@campaign)
		else
			flash[:error] = "There was an error saving the changes to your campaign."
			redirect_to edit_campaign_path(@campaign)
		end
	end

	def find_storyteller
		@storytellers = User.where('email LIKE ?', "#{params[:q]}%")
		render json: @storytellers.map { |st| {id: st.id, email: st.email, display_name: st.display_name}}
	end

	private

	def campaign_params
		params.require(:campaign).permit(:name, :user_administers_campaign, :build_points)
	end
end
