require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author) }

  describe 'DELETE #destroy' do
    context 'question' do
      before do
        add_file_to(question)
      end

      it 'author can delete question attachment' do
        login(author)
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
        expect(response).to_not redirect_to question_path(question)
      end

      it 'user can not delete question attachment' do
        login(user)
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
        expect(response).to redirect_to question_path(question)
      end

      it 'guest can not delete question attachment' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
        expect(response).to have_http_status(401)
      end
    end

    context 'answer' do
      before do
        add_file_to(answer)
      end

      it 'author can delete answer attachment' do
        login(author)
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to change(answer.files, :count).by(-1)
        expect(response).to_not redirect_to answer_path(answer.question)
      end

      it 'user can not delete answer attachment' do
        login(user)
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to_not change(answer.files, :count)
        expect(response).to redirect_to answer_path(answer)
      end

      it 'guest can not delete answer attachment' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to_not change(answer.files, :count)
        expect(response).to have_http_status(401)
      end
    end
  end
end
