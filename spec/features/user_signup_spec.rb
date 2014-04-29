require 'spec_helper'

feature 'User can click Sign Up link in header.' do
  scenario 'Successfully' do
    visit root_path
    click_link 'hSignUpBtn'
  end
end

feature 'User can click Sign Up button.' do
  scenario 'Successfully' do
    visit root_path
    click_link 'navSignUpBtn'
  end
end

feature 'User can Submit Sign Up Information.' do
  scenario 'Successfully' do
    visit new_user_registration_path
    fill_in 'Username', with: 'userName'
    fill_in 'Email', with: 'email@email.com'
    fill_in 'Password', with: 'password1'
    click_button 'Sign up' 
  end
end