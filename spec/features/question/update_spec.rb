require 'rails_helper'

feature 'Authenticated user can edit his Question', %q{
  In order to correct the Question
  As an author of Question
  I'd like to be able to edit my Question
} do 

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user trying to Edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit Question'
  end

  scenario 'Author trying to Edit Question', js: true do
    sign_in(author)
    visit question_path(question)
    click_on "Edit Question"

    within '.question' do
      fill_in 'question[title]', with: 'edited title'
      fill_in 'question[body]', with: 'edited body'
      click_on 'Save'
  
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to_not have_selector 'textarea'
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
    end
  end

  scenario 'Author trying to Edit Question with errors', js: true do
    sign_in(author)
    visit question_path(question)
    click_on "Edit Question"

    within '.question' do
      fill_in 'question[title]', with: ''
      fill_in 'question[body]', with: ''
      click_on 'Save'
  
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_selector 'textarea'
      expect(page).to have_button "Save"
    end
  end

  scenario "member tries to edit other user's question" do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit Question'
  end
end
