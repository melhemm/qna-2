require 'rails_helper'

feature 'User can write answers for a question', %q{
  In order to write answer to a question
  As an authenticated user
  I'd like to be able to write an answer
} do 

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user can write question', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end
  
    scenario 'write an answer' do

      fill_in 'answer[body]', with: 'text text text'
      click_on 'Create'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'text text text'
    end

    scenario 'write answer with file' do
      fill_in 'answer[body]', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiple sessions' do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'answer[body]', with: 'text text text'
        click_on 'Create'

        expect(current_path).to eq question_path(question)
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text text'
      end
    end
  end

  scenario 'Unauthenticated user tries to write an answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Create'
  end

  scenario 'write answer with errors', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end
end
