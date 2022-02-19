require 'rails_helper'

feature 'Best answer', %q{
  to choose the answer which is the best
  As an authenticated user
  I want to be able to set best answer to my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:member) { create(:user) }
  given!(:answer) { create :answer, question: question, user: member }
  scenario 'Unauthenticated user tries to write an answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Choose the best'
  end

  describe 'Authenticated user is questions author', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end
  
    scenario 'author select best answer' do
      within '.answers' do
        expect(page).to have_link "Choose the best"  
        click_on 'Choose the best'
        expect(page).to have_content 'Best answer:'
      end
    end 
  end

  describe 'Authenticated member' do
    background do
      sign_in(member)
      visit question_path(question)
    end
  
    scenario "member can't select best answer" do
      within '.answers' do
        expect(page).to_not have_link 'Best answer'
      end
    end 
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end
  
    scenario "Unauthenticated can't select best answer" do
      within '.answers' do
        expect(page).to_not have_link 'Best answer'
      end
    end 
  end
end
