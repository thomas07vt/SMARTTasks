class ListsController < ApplicationController

  def new
    @user = User.find(params[:user_id])
    @list = List.new
  end

  def show
    @list = List.find(params[:id])
    @user = @list.user
    #@todos = @list.todos
    @new_todo = Todo.new
    #@completedtodos = @todos.where(completed: true)
    @incompletetodos = @list.todos.where(completed: false)

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
    @list = List.find(params[:id])

    if @list.destroy
      flash[:notice] = "\"#{@list.title}\" was successfully deleted."
    else
      flash[:error] = "There was an error deleting the TODO List. Please try again."
    end

    redirect_to [@list.user]

  end

  def edit
  end

  def index
    redirect_to user_path(current_user)
  end

  def list_params
    params.require(:list).permit(:title)
  end
end
