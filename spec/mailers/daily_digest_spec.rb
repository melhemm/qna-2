require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let!(:user) { create :user }
    let!(:questions) { create_list(:question, 3, user: user) }
    let(:mail) { DailyDigestMailer.digest }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match('DailyDigest')
      questions.each { |question| expect(mail.body.encoded).to match(question.title) }
    end
  end

end
