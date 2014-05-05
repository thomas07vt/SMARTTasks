require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'User should see delete TODO List button' do
  scenario 'Successfully' do
    list = FactoryGirl.create(:list)
    login_as(list.user, :scope => :user)
    visit user_list_path(list.user, list)
    expect(page).to have_content("Delete List")
  end
end