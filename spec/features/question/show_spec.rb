require 'rails_helper'

feature 'User can view the question and answers', %q{
  In order to get find a question and answers
  I'd like to be able to a question
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answers) { create_list(:answer, 3, question: question, user: user) }
  
  scenario 'get a question with answers' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end
end