require 'rails_helper'

feature 'User can add links to question', %q{
  In order to ask questions 
  As an unauthenticated user
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:link) {"https://stackoverflow.com"}
  given!(:question) { create(:question, user: user) }
  
  describe 'User add link when asks question', js: true do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'user ask with links' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      click_on 'Add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'stackoverflow'
        fill_in 'Url', with: link
      end

      click_on 'Ask'
      save_and_open_page

      within '.question' do
        expect(page).to have_link('stackoverflow', href: link)
      end
    end

    scenario 'user ask with err links' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      fill_in "Link name", with: 'string'
      fill_in "Url", with: 'text'
  
      click_on 'Add link'
  
      within all('.nested-fields').last do
        fill_in 'Link name', with: 'stackoverflow'
        fill_in 'Url', with: 'not-link'
      end
  
      click_on 'Ask'
      save_and_open_page
      expect(page).to have_content 'Links url is not a valid URL'
    end
  end
end
