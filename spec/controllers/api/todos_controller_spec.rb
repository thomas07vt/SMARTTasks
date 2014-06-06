require 'spec_helper'

describe Api::V1::TodosController do

  before do
    User.destroy_all
    List.destroy_all
    Todo.destroy_all
  end

  describe "create" do 

    it "creates a todo and returnes an HTTP 200 message with the message [Todo item was created successfully.] " do
      todo = FactoryGirl.create(:todo)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{todo.list.user.email}:#{todo.list.user.password}")
      params = { list_id: todo.list.id, todo_body: "This is a todo body." }

      # post :create, params
      expect{ post :create, params }.to change{ Todo.where(list_id: todo.list.id).count }.by 1

      response.should_not be_error
      response.body.should == 'Todo item was created successfully.'

    end

    it "returns an HTTP error message and a message [Todo item creation failed.] when a todo_body is not supplied " do
      todo = FactoryGirl.create(:todo)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{todo.list.user.email}:#{todo.list.user.password}")
      params = { list_id: todo.list.id }

      # post :create, params
      expect{ post :create, params }.to_not change{ Todo.where(list_id: todo.list.id).count }

      response.should_not be_error
      response.body.should == 'Todo item creation failed.'

    end

    it "returns an HTTP error message and a message [Todo item creation failed.] when a list_id is not supplied " do
      todo = FactoryGirl.create(:todo)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{todo.list.user.email}:#{todo.list.user.password}")
      params = { todo_body: "This is a todo body." }

      # post :create, params
      expect{ post :create, params }.to_not change{ Todo.where(list_id: todo.list.id).count }

      response.should_not be_error
      response.body.should == 'Todo item creation failed.'

    end

    it "returns HTTP 401 error when a user is not authenticated" do
      todo = FactoryGirl.create(:todo)
      params = { list_id: todo.list.id, todo_body: "This is a todo body." }

      # post :create, params
      expect{ post :create, params }.to change{ Todo.where(list_id: todo.list.id).count }.by 0

      response.status.should == 401
      response.body.should == "HTTP Basic: Access denied.\n"

    end

  end

  describe "update" do 

    it "updates a todo and returnes an HTTP 200 message with the message [Todo item was created successfully.] when valid parameters are supplied" do
      todo = FactoryGirl.create(:todo)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{todo.list.user.email}:#{todo.list.user.password}")
      params = { id: todo.list.id, todo_body: "This is a todo body.", completed: "false" }

      post :update, params

      updated_todo = Todo.find(todo.id)
      updated_todo.body.should == "This is a todo body."

      response.should_not be_error
      response.body.should == "Todo item updated successfully."
    end

    it "updates a todo and returnes an HTTP 200 message with the message [Todo item was created successfully.] when valid parameters without completed is suppied" do
      todo = FactoryGirl.create(:todo)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{todo.list.user.email}:#{todo.list.user.password}")
      params = { id: todo.list.id, todo_body: "This is a todo body." }

      post :update, params

      updated_todo = Todo.find(todo.id)
      updated_todo.body.should == "This is a todo body."

      response.should_not be_error
      response.body.should == "Todo item updated successfully."
    end

    it "returns an HTTP error message without a proper todo_body and return the message [Todo item update failed.] " do
      todo = FactoryGirl.create(:todo)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{todo.list.user.email}:#{todo.list.user.password}")
      params = { id: todo.list.id, todo_body: "", completed: "false" }

      post :update, params

      updated_todo = Todo.find(todo.id)
      updated_todo.body.should == todo.body

      response.status.should == 400 
      response.body.should == 'Todo item update failed.'

    end

    it "returns HTTP 401 error when a user is not authenticated" do
      todo = FactoryGirl.create(:todo)
      params = { id: todo.list.id, todo_body: "This is a todo body.", completed: "false" }

      post :update, params

      updated_todo = Todo.find(todo.id)
      updated_todo.should == todo

      response.status.should == 401
      response.body.should == "HTTP Basic: Access denied.\n"

    end

  end
end
