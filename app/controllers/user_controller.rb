class UserController < ApplicationController
	def new

	end

	def create

	end

	def edit

	end

	def update
		@user = User.find(session[:user])
		if @user.update_attributes!(params[:user])
			flash[:success] = "You've updated your settings successfully."
		else
			flash[:error] = "There was an error updating your settings."
		end
		redirect_to edit_user_path(@user)
	end

	def destroy

	end

	private

	def user_params
		params.require(:user).permit(:display_name, :email, :username, :encrypted_password, :current_sign_in_ip, :last_sign_in_ip, :current_sign_in_at, :last_sign_in_at, :reset_password_sent_at, :remember_created_at, :reset_password_token)
	end
end
