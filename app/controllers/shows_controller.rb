class ShowsController < ApplicationController
  # GET /shows
  # GET /shows.json
  def index
    @shows = Show.order("name asc").all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shows }
    end
  end

  # GET /shows/1
  # GET /shows/1.json
  def show
    @show = Show.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @show }
    end
  end

  # GET /shows/new
  # GET /shows/new.json
  def new
    @show = Show.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @show }
    end
  end

  # GET /shows/1/edit
  def edit
    @show = Show.find(params[:id])
  end

  # POST /shows
  # POST /shows.json
  def create
    @show = Show.new(params[:show])

    respond_to do |format|
      begin
        if @show.save
          format.html { redirect_to shows_path(:anchor => @show.id), :flash => { notice: "<strong>Success: </strong> created #{@show.name}.", inline: true } }
          format.json { render json: @show, status: :created, location: @show }
        else
          format.html { redirect_to shows_path, alert: "<strong>Error: </strong> couldn't find show \"#{@show.name}\"." }
          format.json { render json: @show.errors, status: :unprocessable_entity }
        end
      rescue
        # Surpress all errors
        format.html { redirect_to shows_path, alert: "<strong>Error: </strong> couldn't find show \"#{@show.name}\"." }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shows/1
  # PUT /shows/1.json
  def update
    @show = Show.find(params[:id])

    respond_to do |format|
      if @show.update_attributes(params[:show])
        format.html { redirect_to @show, notice: 'Show was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shows/1
  # DELETE /shows/1.json
  def destroy
    @show = Show.find(params[:id])
    @show.destroy

    respond_to do |format|
      format.html { redirect_to shows_url }
      format.json { head :no_content }
    end
  end

  def sync
    @show = Show.find(params[:id])
    pre = @show.episodes.count
    begin
      Episode.pull_episodes(@show)
    rescue
      # Suppress all errors
    ensure
      if pre != @show.episodes.count 
        flash[:notice] = "<strong>Success: </strong> \"#{@show.name}\" updated!"
      else
        flash[:info] = "\"#{@show.name}\" is up to date."
      end
      flash[:inline] = true
      redirect_to shows_path(:anchor => @show.id)
    end
  end
end
