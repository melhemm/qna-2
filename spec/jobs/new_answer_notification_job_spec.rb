require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:service) { double('Service::NewAnswerNotification') }
  let(:user) {create :user}
  let(:question) { create :question, user: user }
  let(:subscriptions) { create_list :subscription, 2, question: question }
  let(:answer) { create :answer, question: question, user: user }

  before do
    allow(Services::NewAnswerNotification).to receive(:new).and_return(service)
  end

  it 'calls Service::NewAnswerNotification#answer_notification' do
    expect(service).to receive(:answer_notification)
    NewAnswerNotificationJob.perform_now(answer)
  end
end
