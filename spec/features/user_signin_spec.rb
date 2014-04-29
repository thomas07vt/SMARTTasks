require 'spec_helper'

feature 'User can click Sign In link in header' do
  scenario 'Successfully' do
    visit root_path
    click_link 'hSignInBtn'
    current_path.should == '/users/sign_in'
  end
end

feature 'User can click Sign In button' do
  scenario 'Successfully' do
    visit root_path
    click_link 'navSignInBtn'
    current_path.should == '/users/sign_in'
  end
end

feature 'User can Submit Sign In Information' do
  scenario 'Successfully' do
    user = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'helloworld'
    click_button 'Sign in'
    current_path.should == root_path
    expect(page).to have_content 'Signed in successfully.'
  end
end

feature 'User cant Sign In with incorrect information' do
  scenario 'Successfully' do
    user = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'badpassword'
    click_button 'Sign in'
    current_path.should == '/users/sign_in'
    expect(page).to have_content 'Invalid email or password.'
  end
end