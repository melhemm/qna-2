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

  describe 'Authenticated user can delete an answer', js: true do
    background do
      sign_in(user)
      visit question_path(answer.question)
    end
  
    scenario 'delete answers link' do
      within all('.answers').first do
        expect(page).to have_link 'stackoverflow', href: 'https://stackoverflow.com'
        click_on 'Edit'
      
        within all('.nested-fields').first do
          click_on 'Delete field'
        end
        click_on 'Save'
      end
    
      within '.answers' do
        expect(page).to_not have_link 'stackoverflow', href: 'https://stackoverflow.com'
      end
    end
  end
end
