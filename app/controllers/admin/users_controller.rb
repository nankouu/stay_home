class Admin::UsersController < ApplicationController
	before_action :authenticate_admin!
  def index
  	@users = User.all
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
    user = User.find(params[:id]) #ユーザ毎の情報を得る
    user.destroy #ユーザ情報を削除（退会）
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:name,:image,:introduction)
  end
end
