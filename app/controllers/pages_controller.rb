class PagesController < ApplicationController
  def index
    # if current_user.nil?
    #   render "login"
    # else
    #   render "dashboard"
    # end
    redirect_to shows_path
  end
end
