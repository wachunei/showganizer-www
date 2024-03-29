class WatchlistsController < ApplicationController
  skip_before_filter :user_admin, only: [:show, :index, :my_watchlist, :remove]
  before_action :set_watchlist, only: [:show, :edit, :update, :destroy, :remove]
  before_action :set_show, only: [:remove]

  # GET /watchlists
  # GET /watchlists.json
  def index
    @watchlists = Watchlist.all
  end

  def my_watchlist
    if current_user
      @user = current_user
      @watchlist = current_user.watchlist
      render action: 'show'
    end
  end


  def remove
    if current_user
      if @watchlist.shows.include?(@show)
        @watchlist.shows.delete(@show)
        redirect_to @watchlist, notice: "#{@serial.name} was successfully removed from watchlist!"
      else
        redirect_to @watchlist, notice: "You can't delete #{@serial.name} from watchlist, D'OH!!!"
      end
    end
  end

  # GET /watchlists/1
  # GET /watchlists/1.json
  def show
  end


  # GET /watchlists/new
  def new
    @watchlist = Watchlist.new
  end

  # GET /watchlists/1/edit
  def edit
  end

  # POST /watchlists
  # POST /watchlists.json
  def create
    @watchlist = Watchlist.new(watchlist_params)

    respond_to do |format|
      if @watchlist.save
        format.html { redirect_to @watchlist, notice: 'Watchlist was successfully created.' }
        format.json { render action: 'show', status: :created, location: @watchlist }
      else
        format.html { render action: 'new' }
        format.json { render json: @watchlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /watchlists/1
  # PATCH/PUT /watchlists/1.json
  def update
    respond_to do |format|
      if @watchlist.update(watchlist_params)
        format.html { redirect_to @watchlist, notice: 'Watchlist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @watchlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /watchlists/1
  # DELETE /watchlists/1.json
  def destroy
    @watchlist.destroy
    respond_to do |format|
      format.html { redirect_to watchlists_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_watchlist
      user = User.find(params[:user_id])
      if user 
        @watchlist = Watchlist.find_by(user_id: user.id)
      else 
        @watchlist = Watchlist.find(params[:id])
      end

    end

    def set_show
      @show = Show.find(params[:show_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def watchlist_params
      params.require(:watchlist).permit(:user_id)
    end
end
