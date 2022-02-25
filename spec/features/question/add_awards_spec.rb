require 'rails_helper'

feature 'User can add award to question', %q{
  In order to provide award for my question
  As an question's author
  I'd like to be able to add awards to it
} do

  given(:user) { create :user }
  given!(:question) { create(:question, user: user) }

  scenario 'add award to question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Award title', with: 'awards title'
    attach_file 'Award image', "#{Rails.root}/spec/rails_helper.rb"

    click_on 'Ask'

    expect(user.questions.last.award).to be_a(Award)
  end
end
