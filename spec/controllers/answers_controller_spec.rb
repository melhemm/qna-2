require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'with valid attribute' do
      before { login(user) }

      it 'save answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attribute' do
      before { login(user) }
      it 'does not save the question' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid, question: question), question_id: question }, format: :js }.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid, question: question), format: :js, question_id: question }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    context 'user is an author' do
      let!(:answer) { create :answer, question: question, user: user }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end
    end

    context 'user is not an author' do
      let(:not_an_author) { create :user }
      let(:question) { create :question, user: not_an_author }
      let!(:other_member_answer) { create :answer, question: question, user: not_an_author }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: other_member_answer } }.to_not change(question.answers, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: other_member_answer }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
