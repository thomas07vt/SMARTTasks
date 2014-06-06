require 'spec_helper'

describe Api::V1::ListsController do

  before do
    User.destroy_all
    List.destroy_all
    Todo.destroy_all
  end


  describe "index" do

    it "returns all visible lists for a specified user_id" do
      list = FactoryGirl.create(:list)
      list.permission = "open"
      list.save
      params = { user_id: list.user.id }

      get :index, params.merge(format: :json)

      JSON.parse(response.body).first.should == JSON.parse(list.to_json)

    end
  end

  describe "show" do

    it "returns list and todo items for a specified list id" do
      todo = FactoryGirl.create(:todo)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{todo.list.user.email}:#{todo.list.user.password}")
      todos = []
      todos << todo
      list = todo.list
      list.permission = "open"
      list.save
      json = { list: list, todos: todos }

      params = { id: list.id }

      get :show, params.merge(format: :json)

      JSON.parse(response.body).should == JSON.parse(json.to_json)

    end

    it "returns error when trying to view a private list" do
      todo = FactoryGirl.create(:todo)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{todo.list.user.email}:#{todo.list.user.password}")
      todos = []
      todos << todo
      list = todo.list
      json = { list: list, todos: todos }

      params = { id: list.id }

      get :show, params.merge(format: :json)

      response.body.should == "You are not authroized."

    end

    it "returns HTTP 401 error when a user is not authenticated" do
      todo = FactoryGirl.create(:todo)
      todos = []
      todos << todo
      list = todo.list
      json = { list: list, todos: todos }

      params = { id: list.id }

      get :show, params.merge(format: :json)

      response.status.should == 401
      response.body.should == "HTTP Basic: Access denied.\n"

    end


  end

  describe "create" do 

    it "creates a list and returns an HTTP 200 message with the message [List was created successfully.] " do
      user = FactoryGirl.create(:user)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{user.email}:#{user.password}")
      params = { user_id: user.id, list_title: "list title for testing", permission: "open"}

      # post :create, params
      expect{ post :create, params }.to change{ List.where(user_id: user.id).count }.by 1

      response.should_not be_error
      response.body.should == 'List was created successfully.'

    end

    it "creates a private list if and invalid permission is passed" do
      user = FactoryGirl.create(:user)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{user.email}:#{user.password}")
      params = { user_id: user.id, list_title: "list title for testing", permission: "invalid"}

      # post :create, params
      expect{ post :create, params }.to change{ List.where(user_id: user.id).count }.by 1
      list = List.where(title: "list title for testing").first
      list.permission.should == "private"

      response.should_not be_error
      response.body.should == 'List was created successfully.'

    end

    it "returns an HTTP error message without a list_title and a message [List update failed.] " do
      user = FactoryGirl.create(:user)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{user.email}:#{user.password}")
      params = { user_id: user.id, permission: "open"}

      # post :create, params
      expect{ post :create, params }.to_not change{ List.where(user_id: user.id).count }

      response.status.should == 400
      response.body.should == 'List creation failed.'

    end

    it "returns an HTTP error message without a user_id and a message [List update failed.] " do
      user = FactoryGirl.create(:user)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{user.email}:#{user.password}")
      params = { list_title: "list title for testing", permission: "open"}

      post :create, params

      response.status.should == 400
      response.body.should == 'List creation failed.'

    end

    it "returns HTTP 401 error when a user is not authenticated" do
      user = FactoryGirl.create(:user)
      params = { user_id: user.id, list_title: "list title for testing", permission: "open"}

      # post :create, params
      expect{ post :create, params }.to change{ List.where(user_id: user.id).count }.by 0


      response.status.should == 401
      response.body.should == "HTTP Basic: Access denied.\n"

    end
  end

  describe "update" do 

    it "updates a list and returns an HTTP 200 message with the message [List was updated successfully.] " do
      list = FactoryGirl.create(:list)
      list.permission = "open"
      list.save
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{list.user.email}:#{list.user.password}")
      params = { id: list.id, user_id: list.user.id, list_title: "new list title!", permission: "open"}

      post :update, params

      updated_list = List.find(list.id)
      updated_list.title.should == "new list title!"

      response.should_not be_error
      response.body.should == 'List was updated successfully.'

    end

    it "does not alter the list.permission property if and invalid permission is passed" do
      list = FactoryGirl.create(:list)
      list.permission = "open"
      list.save
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{list.user.email}:#{list.user.password}")
      params = { id: list.id, user_id: list.user.id, list_title: "new list title!", permission: "invalid"}

      post :update, params

      updated_list = List.find(list.id)
      updated_list.title.should == "new list title!"
      updated_list.permission.should == "open"

      response.should_not be_error
      response.body.should == 'List was updated successfully.'

    end

    it "returns an HTTP error message without a proper list_title and return the message [List was updated successfully.] " do
      list = FactoryGirl.create(:list)
      list.permission = "open"
      list.save
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{list.user.email}:#{list.user.password}")
      params = { id: list.id, user_id: list.user.id, list_title: ""}

      post :update, params

      updated_list = List.find(list.id)
      updated_list.title.should == list.title

      response.status.should == 400 
      response.body.should == 'List update failed.'

    end

    it "returns HTTP 401 error when a user is not authenticated" do
      list = FactoryGirl.create(:list)
      list.permission = "open"
      list.save
      params = { id: list.id, user_id: list.user.id, list_title: "new list title!", permission: "open"}

      post :update, params

      updated_list = List.find(list.id)
      updated_list.title.should == list.title

      response.status.should == 401
      response.body.should == "HTTP Basic: Access denied.\n"

    end
  end

  describe "destroy" do 

    it "deletes a list and returns an HTTP 200 message with the message [List was deleted successfully.] " do
      list = FactoryGirl.create(:list)
      list.permission = "open"
      list.save
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{list.user.email}:#{list.user.password}")
      params = { id: list.id }

      post :destroy, params

      List.where(id: list.id).count.should == 0

      response.should_not be_error
      response.body.should == 'List was deleted successfully.'

    end

    it "returns HTTP 401 error when a user is not authenticated" do
      list = FactoryGirl.create(:list)
      params = { id: list.id }

      post :destroy, params

      List.where(id: list.id).count.should == 1

      response.status.should == 401
      response.body.should == "HTTP Basic: Access denied.\n"

    end

  end
end