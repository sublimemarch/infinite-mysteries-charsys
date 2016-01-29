class HomeController < ApplicationController
  def index
    if current_user
      
    else
      redirect_to login_path
    end
  end

end
