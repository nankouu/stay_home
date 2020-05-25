class User::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @users = User.all
    @favorite = Favorite.new
    if params[:category_id]
      @selected_category = Category.find(params[:category_id])
      @posts = Post.from_category(params[:category_id]).page(params[:page])
    else
      @posts = Post.all.page(params[:page])
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    @comment = Comment.new
    @genres = Genre.where(is_valid:'1')
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save!
      redirect_to user_post_path(@post)
    else
      @posts = Post.all
      @user = current_user
      render :index
    end
  end

  def edit
    @post = Post.find(params[:id])
    @category_list = @post.categories.pluck(:name).join(",")
  end

  def update
    @post = Post.find(params[:id])
    category_list = params[:category_list]
    if @post.update_attributes(post_params)
      @post.save_categories(category_list)
      redirect_to user_post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    redirect_to user_posts_path
  end

  def search
    @posts = Post.search(params[:search])
  end

  def following_posts
    @posts_all = Post.includes(:user,:favorites)
    @user = User.find(current_user.id)
    @follow_users = @user.following_user
    @posts = @posts_all.where(user_id: @follow_users).order("created_at DESC").page(params[:page]).per(10)
  end

  private
    def post_params
      params.require(:post).permit(:title,:body,:image,:genre_id,:tag_list)
    end
end
