class User::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all
    @post = Post.new
    @user = current_user
    @favorite = Favorite.new
  end

  def show
    @post = Post.find_by(id: params[:id])
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to user_post_path(@post)
    else
      @posts = Post.all
      @user = current_user
      render :index
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    if @post.update(post_params)
      redirect_to user_post_path(@post)
    else
      render :show
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

  private
  def post_params
    params.require(:post).permit(:title,:body)
  end
end
