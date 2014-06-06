require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'API responds to lists index call with user_id supplied' do
  scenario 'Successfully' do
    list = FactoryGirl.create(:list)
    visit api_v1_lists_path(user_id: list.user.id)
    expect(page).to have_content(list.title)
    expect(page).to have_content(list.user_id)
  end
end

# Will need to add feature to test list permissions.

feature 'API responds empty to lists index call without user_id supplied' do
  scenario 'Successfully' do
    list = FactoryGirl.create(:list)
    visit api_v1_lists_path()
    expect(page).to_not have_content(list.title)
    expect(page).to_not have_content(list.user_id)
  end
end

feature 'API responds with list info to single list call when list id is supplied' do
  scenario 'Successfully' do
    list = FactoryGirl.create(:list)
    visit api_v1_list_path(id: list.id)
    expect(page).to have_content(list.title)
    expect(page).to have_content(list.user_id)
  end
end

feature 'API responds with todo info to single list call when list id is supplied' do
  scenario 'Successfully' do
    todo = FactoryGirl.create(:todo)
    list = todo.list
    visit api_v1_list_path(id: list.id)
    expect(page).to have_content(todo.body)
  end
end

