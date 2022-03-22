require 'rails_helper'

feature 'Subscriptions' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)

      click_on 'Subscribe'
    end

    scenario 'subscribes to a question', js: true do
      expect(current_path).to eq question_path(question)
      save_and_open_page
      expect(page).to_not have_link 'Subscribe'
      save_and_open_page
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'unsubscribes from question', js: true do
      click_on 'Unsubscribe'

      expect(page).to_not have_link 'Unsubscribe'
      save_and_open_page
      expect(page).to have_link 'Subscribe'
    end
  end

  context 'unsubscribed user' do
    given(:guest) { create(:user) }
    given!(:subscription) { create(:subscription, user: user, question: question) }

    scenario 'does not sees unsubscribe link' do
      sign_in(guest)
      visit question_path(question)

      expect(page).to have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  context 'Non-authenticated' do
    it 'does not sees subscribes links' do
      visit question_path(question)

      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end
