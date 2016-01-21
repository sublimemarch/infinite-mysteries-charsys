class CampaignsController < ApplicationController
	before_action :authenticate_user!
	
	def index
		@campaigns = Campaign.where({user_id: current_user})
	end
	
	def show
		@campaign = Campaign.find(params[:id])
		unless @campaign.users.include?(current_user)
			redirect_to campaigns_path
		end
	end

	def new
		@campaign = Campaign.new
	end

	def create
		@campaign = Campaign.new(campaign_params)
		@users = params[:user_administers_campaign][:user_id].split(",")
		# make sure users don't forget to make themselves a storyteller
		puts @users
		puts current_user.id
		unless @users.include?(current_user.id.to_s)
			@users << current_user.id
		end
		if @campaign.save!
			@users.each do |user|
				@admin = UserAdministersCampaign.new({user_id: user, campaign_id: @campaign.id})
				@admin.save!
			end
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
		@users = params[:user_administers_campaign][:user_id].split(",")
		@admins = UserAdministersCampaign.where({campaign_id: @campaign.id})
		# make sure users can't delete themselves from the list
		unless @users.include?(current_user.id.to_s)
			@users << current_user.id
		end
		if @campaign.update_attributes!(campaign_params)
			# add new admins
			@users.each do |user|
				unless UserAdministersCampaign.where({user_id: user.id, campaign_id: @campaign.id}).present?
					@admin = UserAdministersCampaign.new({user_id: user, campaign_id: @campaign_id})
				end
			end
			# delete admins that are no longer on the list
			@admins.each do |admin|
				unless @users.include?(@admin.user_id)
					admin.delete_all
				end
			end
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
