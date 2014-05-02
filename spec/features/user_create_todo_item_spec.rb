require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'User can access his/her todo list collection' do
  scenario 'Successfully' do
    list = FactoryGirl.create(:list)
    login_as(list.user, :scope => :user)
    visit user_lists_path(list.user)
  end
end

feature 'User can see list collection on lists index page' do
  scenario 'Successfully' do
    list = FactoryGirl.create(:list)
    login_as(list.user, :scope => :user)
    visit user_lists_path(list.user)
    expect(page).to have_content "#{list.title}"
  end
end

feature 'User can click list on index' do
  scenario 'Successfully' do
    list = FactoryGirl.create(:list)
    login_as(list.user, :scope => :user)
    visit user_lists_path(list.user)
    expect(page).to have_content "#{list.title}"
    click_link "#{list.title}"
    current_path.should == user_list_path(list.user, list)
  end
end

feature 'User can click create Todo button' do
  scenario 'Successfully' do
    list = FactoryGirl.create(:list)
    login_as(list.user, :scope => :user)
    visit user_list_path(list.user, list)
    expect(page).to have_content "#{list.title}"
    click_link 'Create New Todo Item'
  end
end

feature 'After create to-do button is clicked, new Todo field up' do
  scenario 'Successfully' do
    list = FactoryGirl.create(:list)
    login_as(list.user, :scope => :user)
    visit user_list_path(list.user, list)
    Capybara.ignore_hidden_elements = true
    expect(page).to_not have_content "#newTODO"
    click_link 'Create New Todo Item'
    #wait_for_ajax  ## <<--- Doesn't work for some reason
    find("#newTODO") ### <<--- This will wait for the ajax call I think.
    page.should have_selector(:link_or_button, 'Save')
  end
end

feature 'User should be able to see new Todo' do
  scenario 'Successfully' do
    todo = FactoryGirl.create(:todo)
    list = todo.list
    login_as(list.user, :scope => :user)
    visit user_list_path(list.user, list)
    expect(page).to have_content(todo.body)
  end
end

feature 'User should not be able to see invalid Todo' do
  scenario 'Successfully' do
    list = FactoryGirl.create(:list)
    login_as(list.user, :scope => :user)
    todo = list.todos.build(attributes_for(:todo))
    todo.body = '||'
    todo.save # <-- that will fail
    visit user_list_path(list.user, list)
    expect(page).to_not have_content(todo.body)
  end
end