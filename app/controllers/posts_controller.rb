class PostsController < ApplicationController
  skip_before_filter :user_admin, only: [:show, :index, :add, :destroy, :create, :delete_photo]
  skip_before_filter :authorize, only: [:index, :show, :create] 
  before_action :set_post, only: [:show, :edit, :update, :destroy, :delete_photo]

  # GET /posts
  # GET /posts.json
  # def index
  #   @posts = @parent.posts
  #   respond_to do |format|
  #     format.html {redirect_to polymorphic_path(@array_parent)}
  #     format.js
  #   end
  # end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    redirect_to polymorphic_path(@array_parent)
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @parent.posts << @post

    respond_to do |format|
      if @post.save
        u=User.find_by_id(@post.user_id)
        u.score_update(@parent)
        format.html { redirect_to polymorphic_path(@array_parent)+"/posts", notice: 'Post was successfully created.' }
        format.js         
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { redirect_to polymorphic_path(@array_parent)+"/posts", alert: @post.errors.full_messages.first }
        format.js { render action: 'error', object: @post.errors }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to polymorphic_path(@array_parent)+"/posts", notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    delete_photo
    u=User.find_by_id(@post.user_id)
    u.score_update(nil)
    respond_to do |format|
      format.js 
      format.html { redirect_to polymorphic_path(@array_parent)+"/posts", notice: 'Your post was deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def delete_photo
      @post.photo.destroy
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
       params.require(:post).permit(:user_id, :content, :commentable_id, :photo, :url, :url_title, :post_type)
    end
end
