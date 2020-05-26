class User::UsersController < ApplicationController
	before_action :authenticate_user!

  def index
    @users = User.search(params[:search])
  end

   def show
    @user = User.find_by(id: params[:id])
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update!(user_params)
  		redirect_to user_user_path(@user)
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
    @users= @user.following_user
  end

  def followers
  	@user = User.find(params[:id])
  	@users = @user.follower_user
  end

  def search
  	@users = User.search(params[:search])
  end

  private
  def user_params
  	params.require(:user).permit(:name,:image,:introduction)
  end


end

