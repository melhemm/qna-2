require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to ask answer 
  As an unauthenticated user
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) {'https://gist.github.com/melhemm/9c86bc772b834a2e92dc8b1734c3c5c6'}
  given!(:link) {"https://stackoverflow.com"}

  describe 'Authenticated user can write question', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end
  
    scenario 'write an answer with link' do

      fill_in 'answer[body]', with: 'text text text'
      fill_in 'Link name', with: "My gist"
      fill_in 'Url', with: gist_url

      click_on 'Add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'stackoverflow'
        fill_in 'Url', with: link
      end

      click_on 'Create'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'text text text'
      
      within '.answers' do
        expect(page).to have_link('My gist', href: gist_url)
        expect(page).to have_link('stackoverflow', href: link)
      end
    end

    scenario 'write an answer with err link' do

      fill_in 'answer[body]', with: 'text text text'
      fill_in 'Link name', with: "My gist"
      fill_in 'Url', with: "String"

      click_on 'Add link'
  
      within all('.nested-fields').last do
        fill_in 'Link name', with: 'stackoverflow'
        fill_in 'Url', with: 'not-link'
      end
      
      click_on 'Create'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Links url is not a valid URL'
    end
  end
end
