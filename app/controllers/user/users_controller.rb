class User::UsersController < ApplicationController
	before_action :authenticate_user!

  def index
  	@users = User.all
  end

  def show
  	@user = User.find_by(id: params[:id])
  end

  def edit
  	@user = User.find_by(id: params[:id])
  end

  def update
  	@user = User.find_by(id: params[:id])
  	if @user.update(user_params)
  		redirect_to user_user_path
  	else
  		render :edit
  	end
  end

  #退会する
  def destroy
    @user = User.find(current_user.id)
    @user.toggle!(:is_cancel)
    reset_session
    redirect_to root_path
  end

  def follows
  	@user = User.find(params[:id])
  	@users = @user.follower_user
  end

  def followers
  	@user = User.find(params[:id])
  	@users= @user.follower_user
  end

  def search
  	@user_or_post = params[:option]
  	@how_search = params[:choice]
  	if @user_or_post == "1"
  		@users = User.search(params[:search],@user_or_post,@how_search)
  	else
  		@posts = Post.search(params[:search],@user_or_post,@how_search)
	  end
  end

  private
  def user_params
  	params.require(:user).permit(:name,:image)
  end


end

