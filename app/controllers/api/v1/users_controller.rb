module Api
  module V1
    class UsersController < ApplicationController
      before_filter :authenticate, except: :index
      protect_from_forgery except: :create

      respond_to :json

      def index
        users = User.all.select(:id, :username)
        json = { users: users }
        respond_with json
      end

      def create
        new_user = User.new(user_params)
        new_user.skip_confirmation!

        if new_user.save
          render status: :ok, :text => "User was created successfully."
        else
          render status: :bad_request, :text => "User creation failed."
        end
      end

    private

    def user_params
      {username: params[:username], email: params[:email], password: params[:pass]}
    end

    end
  end
end