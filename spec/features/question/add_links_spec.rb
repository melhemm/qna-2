require 'rails_helper'

feature 'User can add links to question', %q{
  In order to ask questions 
  As an unauthenticated user
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) {'https://gist.github.com/melhemm/9c86bc772b834a2e92dc8b1734c3c5c6'}
  
  scenario 'User add link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in "Link name", with: "My gist"
    fill_in "Url", with: gist_url
    
    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
