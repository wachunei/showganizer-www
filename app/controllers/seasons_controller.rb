class SeasonsController < ApplicationController
  include UserReviewsPosts

  skip_before_filter :user_admin, only: [:show, :index, :show_reviews, :show_posts, :seen, :unseen]
  skip_before_filter :authorize, only: [:show, :index, :show_reviews, :show_posts]
  before_action :set_serial
  before_action :set_season, except: [:index, :create, :new]
  before_action :set_reviews, only: [:show, :show_reviews]
  before_action :set_posts, only: [:show, :show_posts]

  # GET /seasons
  # GET /seasons.json
  def index
    @seasons = @serial.seasons
  end

  # GET /seasons/1
  # GET /seasons/1.json
  def show
  end

  # GET /seasons/new
  def new
    @season = Season.new
  end

  # GET /seasons/1/edit
  def edit
  end

  # POST /seasons
  # POST /seasons.json
  def create
    @serial = Serial.find(params[:serial_id])
    @season = Season.new(season_params)
    @season.serial_id = @serial.id

    respond_to do |format|
      if @season.save
        format.html { redirect_to [@serial,@season], notice: 'Season was successfully created.' }
        format.json { render action: 'show', status: :created, location: @season }
      else
        format.html { render action: 'new' }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seasons/1
  # PATCH/PUT /seasons/1.json
  def update
    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to [@serial,@season], notice: 'Season was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.json
  def destroy
    @season.destroy
    respond_to do |format|
      format.html { redirect_to serial_seasons_url }
      format.json { head :no_content }
    end
  end

  def seen
    if current_user
      @season.episodes.each do |episode|
        unless current_user.watched.episodes.include?(episode)
          current_user.watched.episodes << episode
          current_user.score_update(nil)
        end
      end 
      respond_to do |format|
          format.html { redirect_to serial_season_url(@serial,@season), notice: "This whole season was marked as seen!" }
          format.js { render 'layouts/update_action_menu' }
      end
    end
  end

  def unseen
    if current_user
      @season.episodes.each do |episode|
        if current_user.watched.episodes.include?(episode)
          current_user.watched.episodes.delete(episode)
          current_user.score_update(nil)
        end
      end 
      respond_to do |format|
          format.html { redirect_to serial_season_url(@serial,@season), notice: "This whole season was marked as unseen!" }
          format.js { render 'layouts/update_action_menu' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_season
      @season = @serial.seasons.find_by(number: params[:id])
    end

    def set_serial
      @serial = Serial.find(params[:serial_id])
    end

    def set_reviews
      @reviews = @season.reviews
    end
    
    def set_posts
      @posts = @season.posts
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def season_params
      params.require(:season).permit(:description, :date, :number, :serial_id)
    end
end
