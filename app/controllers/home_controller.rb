class HomeController < ApplicationController
  def index
    if current_user
      @campaigns = current_user.campaigns
      @characters = current_user.characters
    else
      redirect_to new_user_session_path
    end
  end

end
