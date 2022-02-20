require 'rails_helper'

feature 'Authenticated user can edit his answer', %q{
  In order to correct the answer
  As an author of answer
  I'd like to be able to edit my answer
} do 

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated user trying to Edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  scenario 'author can edit his answer', js: true do
    sign_in(author)
    visit question_path(question)
    expect(page).to have_content "MyText"
    click_on "Edit"

    within '.answers' do
      fill_in "Your answer", with: "edited answer"
      click_on 'Save'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario 'author can edit his answer', js: true do
    sign_in(author)
    visit question_path(question)
    expect(page).to have_content "MyText"
    click_on "Edit"

    within '.answers' do
      fill_in "Your answer", with: ""
      click_on 'Save'

      expect(page).to have_content answer.body
      expect(page).to have_selector 'textarea'
    end
  end

  scenario 'author can edit his answer with attached files', js: true do
    sign_in(author)
    visit question_path(question)
    click_on "Edit"

    within '.answers' do
      attach_file 'answer[files][]', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'
      save_and_open_page
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario "member tries to edit other user's question" do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
