require 'rails_helper'

feature 'User can sign up', %q{
  In order to be a member 
  As an unauthorized user
  I'd like to be able to sign up
} do

  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Unregistered user tires to sign up' do
    
    fill_in 'Email', with: 'jimmydaa@gmail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    save_and_open_page
    expect(page).to have_content 'Welcome! You have signed up successfully.'  
  end

  scenario 'registered user tires to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    save_and_open_page
    expect(page).to have_content 'Email has already been taken'  
  end
end
