require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to ask answer 
  As an unauthenticated user
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:link) { create :link, linkable: answer, name: 'stackoverflow', url: 'https://stackoverflow.com' }

  describe 'Authenticated user can write an answer', js: true do
    background do
      sign_in(user)
      visit question_path(answer.question)
    end

    scenario 'edit answers link', js: true do
      within all('.answers').first do
        expect(page).to have_link 'stackoverflow', href: 'https://stackoverflow.com'
        click_on 'Edit'
      
        within all('.nested-fields').first do
          fill_in 'Link name', with: "Mygist"
          fill_in 'Url', with: 'https://stackoverflow.com/4234234'
        end
        click_on 'Save'
      end
    
      within '.answers' do
        expect(page).to_not have_link 'stackoverflow', href: 'https://stackoverflow.com'
        expect(page).to have_link 'Mygist', href: 'https://stackoverflow.com/4234234'
      end
    end

    scenario 'edit an answer with err link', js: true do
      fill_in 'answer[body]', with: 'text text text'
      fill_in 'Link name', with: "My gist"
      fill_in 'Url', with: "String"

      click_on 'Add link'
  
      within all('.nested-fields').last do
        fill_in 'Link name', with: 'stackoverflow'
        fill_in 'Url', with: 'not-link'
      end
      
      click_on 'Create'
      
      expect(page).to have_content 'Links url is not a valid URL'
    end
  end
end
