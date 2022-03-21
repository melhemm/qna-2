require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:user) { create(:user) }
  let(:question) { create :question, user: user }
  let(:subscriptions) { create_list :subscription, 2, question: question }
  let(:answer) { create :answer, question: question, user: user }

  it 'sends notification for new answer' do
    question.subscriptions.each do |subscription|
      expect(NewAnswerMailer).to receive(:new_answer).with(subscription.user, answer).and_call_original
    end
  end
end
