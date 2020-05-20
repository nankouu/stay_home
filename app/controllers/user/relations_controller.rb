class User::RelationsController < ApplicationController
	before_action :authenticate_user!

	def follow #フォローする
		current_user.follow(params[:id])
		redirect_to request.referer
	end

	def unfollow #フォローを外す
		current_user.unfollow(params[:id])
		redirect_to request.referer
	end

	def follows
		@user = User.find(params[:id])
		@users = @user.following_user
	end

	def followers
		@user = User.find(params[:id])
		@users = @user.following_user
	end
end
