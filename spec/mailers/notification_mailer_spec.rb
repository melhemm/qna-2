require "rails_helper"

RSpec.describe NewAnswerMailer, type: :mailer do
  describe "new_answer" do
    let(:user) { create(:user) }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, question: question, user: user }
    let(:mail) { NewAnswerMailer.new_answer(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq('New answer')
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the answer body" do
      expect(mail.body.encoded).to match(question.title)
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
