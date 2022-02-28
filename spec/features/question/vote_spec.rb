require 'rails_helper'

feature 'Member can vote for question' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given(:vote) { create(:vote, votable: question) }

  describe 'Authenticated member want to vote' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'member like a question', js: true do
      click_on 'Like'
      save_and_open_page

      expect(page).to have_content 'Rating: 1'
      expect(page).to have_content 'You voted'
      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
    end

    scenario 'member dislike a question', js: true do
      click_on 'Dislike'
      save_and_open_page

      expect(page).to have_content 'Rating: -1'
      expect(page).to have_content 'You voted'
      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
    end
  end

  scenario 'member want to recote a question', js: true do
    sign_in(vote.user)
    visit question_path(question)

    click_on 'Revote'
    save_and_open_page

    expect(page).to have_content 'Rating: 0'
    expect(page).to have_link 'Like'
    expect(page).to have_link 'Dislike'
  end

  scenario 'Author of question want to like or dislike' do
    sign_in(question.user)
    visit question_path(question)
    save_and_open_page

    expect(page).to_not have_link 'Like'
    expect(page).to_not have_link 'Dislike'
  end

  scenario 'Unauthenticated member want to like or dislike' do
    visit question_path(question)
    save_and_open_page
    
    expect(page).to_not have_link 'Like'
    expect(page).to_not have_link 'Dislike'
  end
end
