module Api
  module V1
    class ListsController < ApplicationController
      before_filter :authenticate, except: :index

      protect_from_forgery except: :create
      respond_to :json
      
      def index
        user_id = params[:user_id]
        respond_with List.where("user_id = ? and permission != ?", user_id, "private")
      end

      def show

        lists = List.where("id = ? and permission != ?", params[:id], "private")
        if lists.any?
          list = lists.first
          todos = list.todos.where(completed: false)
          json = { list: list, todos: todos }
          respond_with json
        else
          render status: :bad_request, :text => "You are not authroized."
        end
      end
      
      def create
        user = User.find(params[:user_id])
        list = user.lists.build(list_params)
        #authorize(@list)
        if list.save
          render status: :ok, :text => "List was created successfully."
        else
          render status: :bad_request, :text => "List creation failed."
        end

      rescue
        render status: :bad_request, :text => "List creation failed."
      end
      
      def update
        lists = List.where("id = ? and permission = ?", params[:id], "open")

        if lists.any?
          list = lists.first
          if list.update_attributes(list_params)
            render status: :ok, :text => "List was updated successfully."
          else
            render status: :bad_request, :text => "List update failed."
          end
        else
          render status: :unauthorized, :text => "You are not authroized."
        end
          
      end
      
      def destroy
        lists = List.where("id = ? and permission = ?", params[:id], "open")

        if lists.any?
          list = lists.first
          if list.destroy
            render status: :ok, :text => "List was deleted successfully."
          else
            render status: :bad_request, :text => "List deletion failed."
          end
        else
          render status: :unauthorized, :text => "You are not authroized or this list does not exist."
        end
        
      rescue
        render status: :bad_request, :text => "List deletion failed."
      end

      private

      def list_params
        list_params = {title: params[:list_title]}
        list_params[:permission] = params[:permission] if List.valid_permission?(params[:permission])
        list_params
      end

    end
  end
end

