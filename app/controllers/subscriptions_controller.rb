class SubscriptionsController < ApplicationController

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = Subscription.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscriptions }
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription = Subscription.find(params[:id])
    show = @subscription.show
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to shows_url(:anchor => show.id), :flash => { alert: "Stopped tracking \"#{show.name}\".", inline: true} }
      format.json { head :no_content }
    end
  end

  def subscribe
    if current_user.nil?
      redirect_to login_path 
    else
      @show = Show.find(params[:id])
      next_ep = @show.prev_episode(Episode.where(season_number: params[:season].to_i, episode_number: params[:episode].to_i).first)
      episode_id = next_ep ? next_ep.id : nil
      Subscription.create(user_id: current_user.id, show_id: @show.id, episode_id: episode_id)

      respond_to do |format|
        format.html { redirect_to shows_url(:anchor => @show.id), :flash => { track: "Started tracking \"#{@show.name}\".", inline: true} }
        format.json { head :no_content }
      end
    end
  end

  def list
    if params[:id]
      user = User.find(params[:id]) 
    else
      user = current_user
    end
    @subscriptions = user.subscriptions

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscriptions }
    end
  end

  def watch
    @subscription = Subscription.find(params[:id])
    @subscription.episode = @subscription.show.next_episode(@subscription.episode)
    if @subscription.episode.nil?
      head :bad_request 
    else
      @subscription.save
      render :partial => "list_item", :layout => false, :locals =>{:subscription => @subscription}
    end
  end

  def unwatch
    @subscription = Subscription.find(params[:id])
    if @subscription.episode.nil?
      head :bad_request
    else
      @subscription.episode = @subscription.show.prev_episode(@subscription.episode)
      @subscription.save
      render :partial => "list_item", :layout => false, :locals =>{:subscription => @subscription}
    end
  end
end