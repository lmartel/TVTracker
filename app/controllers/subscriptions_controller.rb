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
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to subscriptions_url }
      format.json { head :no_content }
    end
  end

  def subscribe
    if current_user.nil?
      redirect_to login_path 
    else
      @show = Show.find(params[:id])
      Subscription.create(user_id: current_user.id, show_id: @show.id)
      redirect_to track_path
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
    @subscription.save
    render :partial => "list_item", :layout => false, :locals =>{:subscription => @subscription}
  end
end