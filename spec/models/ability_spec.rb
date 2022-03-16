require 'rails_helper'
require "cancan/matchers"

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create(:question, user: user) }
    let(:question_other) { create(:question, user: other) }
    let(:answer) { create(:answer, user: user) }
    let(:answer_other) { create(:answer, user: other) }
    let(:comment) { create(:comment, commentable: question, user: user) }
    let(:comment_other) { create(:comment, commentable: question, user: other) }
    let(:comment_answer) { create(:comment, commentable: answer, user: user) }
    let(:comment_other_answer) { create(:comment, commentable: answer, user: other) }
    let(:link) { create(:link, linkable: question) }
    let(:link_other) { create(:link, linkable: question_other) }
    let(:link_answer) { create(:link, linkable: answer) }
    let(:link_other_answer) { create(:link, linkable: answer_other) }
    let(:vote_question) { create(:vote, user: user, votable: question) }
    let(:vote_answer) { create(:vote, user: user, votable: answer) }
    let(:vote_other_question) { create(:vote, user: other, votable: question_other) }
    let(:vote_other_answer) { create(:vote, user: other, votable: answer_other) }
    let(:question_file) { create(:question, :files, user: user) }
    let(:question_other_file) { create(:question, :files, user: other) }
    let(:answer_file) { create(:answer, :files, user: user) }
    let(:answer_other_file) { create(:answer, :files, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question_other, user: other) }
    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question_other, user: other) }

    it { should be_able_to :update, create(:answer, question: question, user: user) }
    it { should_not be_able_to :update, create(:answer_other, question: question, user: other) }
    it { should be_able_to :destroy, create(:answer, question: question, user: user) }
    it { should_not be_able_to :destroy, create(:answer, question: question, user: other) }

    it { should be_able_to :update, comment }
    it { should_not be_able_to :update, comment_other }
    it { should be_able_to :destroy, comment }
    it { should_not be_able_to :destroy, comment_other }

    it { should be_able_to :update, comment_answer }
    it { should_not be_able_to :update, comment_other_answer }
    it { should be_able_to :destroy, comment_answer }
    it { should_not be_able_to :destroy, comment_other_answer }

    it { should be_able_to :destroy, link }
    it { should_not be_able_to :destroy, link_other }
    it { should be_able_to :destroy, link_answer }
    it { should_not be_able_to :destroy, link_other_answer }

    it { should be_able_to :vote, vote_question }
    it { should be_able_to :vote, vote_answer }
    it { should be_able_to :revote, vote_question }
    it { should be_able_to :revote, vote_answer }

    it { should_not be_able_to :vote, vote_other_question }
    it { should_not be_able_to :vote, vote_other_answer }
    it { should_not be_able_to :revote, vote_other_question }
    it { should_not be_able_to :revote, vote_other_answer }

    it { should be_able_to :destroy, question_file.files.last }
    it { should_not be_able_to :destroy, question_other_file.files.last }
    it { should be_able_to :destroy, answer_file.files.last }
    it { should_not be_able_to :destroy, answer_other_file.files.last }
  end
end
