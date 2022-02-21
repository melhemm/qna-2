require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to ask answer 
  As an unauthenticated user
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) {'https://gist.github.com/melhemm/9c86bc772b834a2e92dc8b1734c3c5c6'}
  
  scenario 'User add link when asks answer', js: true do
    sign_in(user)
    visit new_question_path(question)

    fill_in 'Your answer', with: 'My answer'
    fill_in 'Link name', with: "My gist"
    fill_in 'Url', with: gist_url

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
