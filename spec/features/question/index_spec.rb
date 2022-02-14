require 'rails_helper'

feature 'User can get all questions', %q{
  In order to get find a question
  I'd like to be able to get all questions
} do 

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'get all questions' do
    visit root_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end
