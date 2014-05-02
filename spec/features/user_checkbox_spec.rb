require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Todo should be unchecked upon creation' do
  scenario 'Successfully' do
    todo = FactoryGirl.create(:todo)
    login_as(todo.list.user, :scope => :user)
    visit user_list_path(todo.list.user, todo.list)
    my_box = find('#todo_completed')
    my_box.should_not be_checked
  end
end

feature 'After Todo is complete, user should see the checkbox is checked' do
  scenario 'Successfully' do
    todo = FactoryGirl.create(:todo)
    login_as(todo.list.user, :scope => :user)
    visit user_list_path(todo.list.user, todo.list)
    my_box = find('#todo_completed')
    my_box.should_not be_checked
    todo.completed = true
    todo.save
    todo.completed.should be_true
    visit user_list_path(todo.list.user, todo.list)
    my_box = find('#todo_completed')
    my_box.should be_checked
  end
end