class PagesController < ApplicationController
  def index
    if current_user.nil?
      redirect_to shows_path
    else
      redirect_to track_path
    end
  end
end
