require 'spec_helper'

describe Api::V1::UsersController do

  before do
    User.destroy_all
  end

  describe "create" do

    it "creates and returns a new user from username and password params" do
      user = FactoryGirl.create(:user)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{user.email}:#{user.password}")
      params = { 'username' => 'testuser', 'email' => 'test@gmail.com', 'password' => 'testpass' }

      expect{ post :create, params.merge(format: :json) }
        .to change{ User.all.count }
        .by 1

      response.body.should == "User was created successfully."
    end

    it "returns an error when not given a password" do
      user = FactoryGirl.create(:user)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{user.email}:#{user.password}")
      params = { 'username' => 'testuser', 'email' => 'test@gmail.com' }

      post :create, params.merge(format: :json)
      response.status.should == 400
      response.body.should == 'User creation failed.'
    end

    it "returns an error when not given a username" do
      user = FactoryGirl.create(:user)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{user.email}:#{user.password}")
      params = { 'password' => 'testpass', 'email' => 'test@gmail.com' }

      post :create, params.merge(format: :json)
      response.status.should == 400
      response.body.should == 'User creation failed.'
    end

    it "returns an error when not given an email" do
      user = FactoryGirl.create(:user)
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{user.email}:#{user.password}")
      params = { 'username' => 'testuser', 'password' => 'testpass' }

      post :create, params.merge(format: :json)
      response.status.should == 400
      response.body.should == 'User creation failed.'
    end

    it "returns HTTP 401 error when a user is not authenticated" do
      user = FactoryGirl.create(:user)
      params = { 'username' => 'testuser', 'email' => 'test@gmail.com', 'password' => 'testpass' }

      expect{ post :create, params.merge(format: :json) }
        .to change{ User.all.count }
        .by 0
        
      response.status.should == 401
      response.body.should == "HTTP Basic: Access denied.\n"

    end

  end

  describe "index" do
    users = []

    before do
      (1..3).each do |n|
        user = FactoryGirl.create(:user)
        users << user.username
      end
    end

    it "lists all usernames and ids" do
      get :index, format: :json

      JSON.parse(response.body).should ==
        { 'users' =>
          [
            { 'id' => 1, 'username' => users[0] },
            { 'id' => 2, 'username' => users[1] },
            { 'id' => 3, 'username' => users[2] }
          ]
        }
    end
  end
end