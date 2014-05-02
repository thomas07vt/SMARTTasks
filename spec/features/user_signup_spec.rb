require 'spec_helper'

feature 'User can click Sign Up link in header' do
  scenario 'Successfully' do
    visit root_path
    click_link 'hSignUpBtn'
    current_path.should == '/users/sign_up'
  end
end

feature 'User can click Sign Up button' do
  scenario 'Successfully' do
    visit root_path
    click_link 'navSignUpBtn'
    current_path.should == '/users/sign_up'
  end
end

feature 'User can Submit Sign Up Information' do
  scenario 'Successfully' do
    visit new_user_registration_path
    fill_in 'Username', with: 'userName'
    fill_in 'Email', with: 'email@email.com'
    fill_in 'Password', with: 'password1'
    fill_in 'Password confirmation', with: 'password1'
    click_button 'Sign up'
    current_path.should == root_path
    expect(page).to have_content ' A message with a confirmation link has been sent to your email address.'
  end
end

feature 'User cant Sign Up with used email address' do
  scenario 'Successfully' do
    visit new_user_registration_path
    user = FactoryGirl.create(:user)
    fill_in 'Username', with: 'userName'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password1'
    fill_in 'Password confirmation', with: 'password1'
    click_button 'Sign up'
    current_path.should == '/users'
    expect(page).to have_content 'Email has already been taken'
  end
end