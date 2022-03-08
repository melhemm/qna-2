require 'rails_helper'

feature 'User can comment on the question', "
 In order to comment a question
 As authenticated user
 I'd like to be able to write comments on a question" do

  given(:user) { create(:user) }
  given(:question) { create :question, user: user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'creates a comment to question' do
      fill_in 'comment[body]', with: 'text text text'
      click_button 'Comment'

      expect(page).to have_current_path question_path(question)

      expect(page).to have_content 'text text text'
    end

    scenario 'creates a comment to question with error' do
      fill_in 'comment[body]', with: ''
      click_button 'Comment'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries trying to create a comment to question' do
    visit question_path(question)
    expect(page).to_not have_content 'Add your comment'
    expect(page).to_not have_link 'Comment'
  end
end