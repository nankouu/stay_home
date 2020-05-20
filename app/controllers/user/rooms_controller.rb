class User::RoomsController < ApplicationController
  def show
  	@messages = Message.all
  end
end
