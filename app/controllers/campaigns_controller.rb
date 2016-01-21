class CampaignsController < ApplicationController
	before_action :authenticate_user!
	
	def index
		@campaigns = current_user.campaigns
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
		@campaign = Campaign.find(params[:id])
		@users = params[:user_administers_campaign][:user_id].split(",")
		@admins = UserAdministersCampaign.where({campaign_id: @campaign.id})
		# make sure users can't delete themselves from the list
		unless @users.include?(current_user.id.to_s)
			@users << current_user.id
		end
		if @campaign.update_attributes!(campaign_params)
			# add new admins
			@users.each do |user|
				unless UserAdministersCampaign.where({user_id: user.to_i, campaign_id: @campaign.id}).present?
					@admin = UserAdministersCampaign.new({user_id: user.to_i, campaign_id: @campaign_id})
				end
			end
			# delete admins that are no longer on the list
			@admins.each do |admin|
				puts admin.inspect
				unless @users.include?(admin.user_id)
					admin.delete
				end
			end
			flash[:success] = "The changes to your campaign were successfully saved."
			redirect_to campaign_path(@campaign)
		else
			flash[:error] = "There was an error saving the changes to your campaign."
			redirect_to edit_campaign_path(@campaign)
		end
	end

	def destroy
		@campaign = Campaign.find(params[:id])
		@campaign.delete
		redirect_to campaigns_path
	end

	def find_storyteller
		@storytellers = User.where('email LIKE ?', "#{params[:q]}%")
		render json: @storytellers.map { |st| { id: st.id, email: st.email, display_name: st.display_name } }
	end

	def get_storytellers
		@campaign = Campaign.find(params[:campaign_id])
		render json: @campaign.users.map { |st| { id: st.id, email: st.email, display_name: st.display_name } }
	end

	def questionnaire
		@campaign = Campaign.find(params[:id])
		@questionnaire_item = QuestionnaireItem.new
	end

	def update_questionnaire
		@campaign = Campaign.find(params[:id])
		@current_questions = QuestionnaireItem.where({campaign_id: params[:id]})
		@questions = params[:campaign]
		@question_ids = []

		@questions.each do |question|
			if question.id.present?
				# Update existing questions
				@question = QuestionnaireItem.find(question[:id])
				@question.update_attributes!({question: question[:question]})
				@question_ids << question[:id]
			else
				# Add new questions
				@question = QuestionnaireItem.new({question: question[:question]})
				@question.save!
			end
		end
		
		# prune questions that have been removed
		@current_questions.each do |old_q|
			unless @question_ids.include?(old_q.id)
				old_q.delete
			end
		end

		redirect_to campaign_path(@campaign)
	end

	private

	def campaign_params
		params.require(:campaign).permit(:name, :user_administers_campaign, :build_points)
	end
end
