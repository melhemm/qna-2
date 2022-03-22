require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should have_one(:award).dependent(:destroy) }
  
  it { should belong_to :user }

  it_behaves_like 'votable'

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it 'have one attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)  
  end

  it {should validate_presence_of :title}
  it {should validate_presence_of :body}

  describe "reputation" do
    let(:user) { create :user }
    let(:question) { build(:question, user: user) }

    it "calls Services::Reputation#calculate" do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
    
  end
  
end
