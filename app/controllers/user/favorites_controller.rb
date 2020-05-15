class User::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
  	@favorites = Favorite.where(user_id: current_user.id)
  end

  def create
  	@post = Post.find(params[:post_id])
  	favorite = @post.favorites.new(user_id: current_user.id)
    favorite.save
    redirect_to request.referer
  end

  def destroy
  	@post = Post.find(params[:post_id])
  	favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
    redirect_to request.referer
  end

  private
    def redirect
      case params[:redirect_id].to_i
      when 0
        redirect_to user_posts_path
      when 1
        redirect_to user_post(@post)
      end
    end
end
