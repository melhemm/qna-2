require 'rails_helper'

feature 'User can logout', %q{
  In order to end the user session 
  As an authenticated user
  I'd like to be able to logout
} do

  given(:user) { create(:user) }

  background { sign_in(user)}

  scenario 'authenticated user want to logout' do
    click_on 'Sign out'
    
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
