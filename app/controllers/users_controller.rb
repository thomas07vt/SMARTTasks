class UsersController < ApplicationController
  before_filter :authenticate_user!


  def show
    @user = User.find(params[:id])
    @lists = @user.lists
  end

  def update
    @user = User.find(params[:id])
  end
end
