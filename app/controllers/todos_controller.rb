class TodosController < ApplicationController
  respond_to :html, :js

  def create
    @user = User.find(params[:user_id])
    @list = List.find(params[:list_id])
    @todo = @list.todos.build(todo_params)

    #authorize(@todo)
    if @todo.save
    else
      flash[:error] = "There was an error adding the todo item. Please try again."
    end

    respond_with(@todo) do |f|
      f.html { redirect_to [@user, @list] }
    end


  end

  def destroy
  end

  def new
    @list = List.find(params[:list_id])
    @user = @list.user
    @todo = Todo.new

    respond_with(@todo) do |f|
      f.html { redirect_to [@user, @list] }
    end
  end

  def update
    @user = User.find(params[:user_id])
    @todo = Todo.find(params[:id])
    #authorize(@topic)
    if @todo.update_attributes(todo_params)
    else
      flash[:error] = "There was an error updating the topic. Please try again."
    end

    respond_with(@todo) do |f|
        f.html { redirect_to [@user, @list] }
      end
  end

  private

  def todo_params
    params.require(:todo).permit(:body, :completed)
  end


end
