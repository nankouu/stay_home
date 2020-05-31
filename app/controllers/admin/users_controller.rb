class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  def index
    @users = User.search(params[:search])
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update!(user_params)
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id]) # ユーザ毎の情報を得る
    user.destroy # ユーザ情報を削除（退会）
    redirect_to admin_users_path
  end

  def search
    @user_or_post = params[:option]
    @how_search = params[:choice]
    if @user_or_post == "1"
      @users = User.search(params[:search], @user_or_post, @how_search)
    else
      @posts = Post.search(params[:search], @user_or_post, @how_search)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :image, :introduction)
  end
end
