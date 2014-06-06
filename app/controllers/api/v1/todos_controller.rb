module Api
  module V1
    class TodosController < ApplicationController
      before_filter :authenticate
      protect_from_forgery except: [:create, :update]

      respond_to :json
         
      def create
        list = List.find(params[:list_id])
        todo = list.todos.build(body: params[:todo_body], completed: false)

        #authorize(@todo)
        if todo.save
          render status: :ok, :text => "Todo item was created successfully."
        else
          render status: :bad_request, :text => "Todo item creation failed."
        end

      rescue
        render status: :bad_request, :text => "Todo item creation failed."
      end

      
      def update
        todo = Todo.find(params[:id])
        # todo = Todo.where(body: params[:todo_body]).first if params[:todo_body]
        # todo = Todo.find(params[:todo_id]) if params[:todo_id]
        body = params[:todo_body] || todo.body
        completed = false
        completed = params[:completed] if params[:completed]

        #authorize(@topic)
        if todo && todo.update_attributes(body: body, completed: completed)
          render status: :ok, :text => "Todo item updated successfully."
        else
          render status: :bad_request, :text => "Todo item update failed."
        end
      end

      # private
      # def todo_params
      #   params.permit(:todo_body, :todo_id)
      # end

    end
  end
end
