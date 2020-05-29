class Admin::PostsController < ApplicationController
	before_action :authenticate_admin!
  def index
  	@posts = Post.search(params[:search])
  end

  def show
  	@post = Post.find_by(id: params[:id])
  end
end
