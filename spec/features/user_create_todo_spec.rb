require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'User can click see create new list from user homepage' do
  scenario 'Successfully' do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit user_path(user)
    click_link 'Create New List'
    current_path.should == "/users/#{user.id}/lists/new"
  end
end

feature 'User can click new list from user homepage' do
  scenario 'Successfully' do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit user_path(user)
    click_link 'New List'
    current_path.should == "/users/#{user.id}/lists/new"
  end
end

feature 'User can create new todo list' do
  scenario 'Successfully' do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit new_user_list_path(user)
    fill_in 'Enter title here...', with: 'My First List'
    click_button 'Create List'
    expect(page).to have_content "New list successfully created."
  end
end


feature 'User cant create new todo list without a title.' do
  scenario 'Successfully' do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit new_user_list_path(user)
    click_button 'Create List'
    expect(page).to have_content "There was an error creating the list. Please try again."
  end
end

