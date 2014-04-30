class ListsController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @list = List.new
  end

  def show
  end

  def update
  end

  def create
    @list = current_user.lists.build(list_params)

    #authorize(@list)
    if @list.save
      flash[:notice] = "New list successfully created."
      redirect_to [current_user, @list]
    else
      flash[:error] = "There was an error creating the list. Please try again."
      redirect_to new_user_list_path(current_user)
    end

  end

  def destroy
  end

  def edit
  end

  def index
  end

  def list_params
    params.require(:list).permit(:title)
  end
end
