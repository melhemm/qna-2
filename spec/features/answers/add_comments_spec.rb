require 'rails_helper'

feature 'User can comment answer', "
 In order to comment an answer
 As authenticated user
 I'd like to be able to write comments to an answer" do
 
  given(:user) { create(:user) }
  given(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'creates a comment to answer' do
      within '.answers' do
        fill_in 'comment[body]', with: 'text text text'
        click_button 'Comment'

        expect(page).to have_current_path question_path(question)
        expect(page).to have_content 'text text text'
      end
    end

    scenario 'creates a comment to answer with error' do
      within '.answers' do
        fill_in 'comment[body]', with: ''
        click_button 'Comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user want to add a comment to answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Add your comment'
    end
  end

end
