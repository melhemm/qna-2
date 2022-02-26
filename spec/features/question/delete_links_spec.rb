require 'rails_helper'

feature 'User can add links to question', %q{
  In order to ask questions 
  As an unauthenticated user
  I'd like to be able to add links
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:link) { create :link, linkable: question, name: 'stackoverflow', url: 'https://stackoverflow.com' }
  
  describe 'Author remove link when asks question', js: true do
    background do
      sign_in(author)
      visit question_path(question.id)
      save_and_open_page
    end

    scenario 'user delete link' do
      click_on "Edit Question"

      within ('.question') do
        click_on 'Delete field'
      end

      click_on "Save"

      expect(page).to_not have_content link.name
      expect(page).to_not have_content link.url
    end
  end

  describe 'unauthenticated user want remove link when asks question' do
    background do
      sign_in(user)
      visit question_path(question.id)
      save_and_open_page
    end

    scenario 'user delete link' do
      expect(page).to_not have_link 'Edit Question' 
    end
  end
end
