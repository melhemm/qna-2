require 'rails_helper'

feature 'Member can vote for answer' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given(:vote) { create(:vote, votable: answer) }

  describe 'Member want to vote' do
    background do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content 'Rating: 0'
        expect(page).to have_link 'Like'
        expect(page).to have_link 'Dislike'
      end
    end

    scenario 'Author of answer want to vote' do
      sign_in(answer.user)
      visit question_path(question)
      save_and_open_page
      within '.answers' do
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
      end
    end
  
    scenario 'a member want to revote', js: true do
      sign_in(vote.user)
      visit question_path(question)
      save_and_open_page
      within '.answers' do
        expect(page).to have_content 'Rating: 1'
        expect(page).to have_content 'You voted'
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
        expect(page).to have_link 'Revote'
  
        click_on 'Revote'
        save_and_open_page
  
        expect(page).to have_content 'Rating: 0'
        expect(page).to have_link 'Like'
        expect(page).to have_link 'Dislike'
      end
    end

    scenario 'member want to like answer', js: true do
      sign_in(user)
      visit question_path(question)
      within '.answers' do
        save_and_open_page
        click_on 'Like'
        save_and_open_page

        expect(page).to have_content 'Rating: 1'
        expect(page).to have_content 'You voted'
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
      end
    end

    scenario 'member want to dislike answer', js: true do
      within '.answers' do
        click_on 'Dislike'
        save_and_open_page

        expect(page).to have_content 'Rating: -1'
        expect(page).to have_content 'You voted'
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
      end
    end
  end
end
