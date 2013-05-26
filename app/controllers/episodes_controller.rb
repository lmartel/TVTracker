class EpisodesController < ApplicationController
  def list
    @show = Show.find(params[:id])

    respond_to do |format|
      format.html # list.html.erb
      format.json { render json: @show.episodes }
    end
  end
end