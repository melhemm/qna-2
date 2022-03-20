require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:user) { create :user }
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let!(:question) { create(:question, user: user) }

    it_behaves_like 'API Unauthorizable'

    context 'authorized' do
      let(:user) { create :user }
      let(:answer_response) { json['answers'].first }
      let!(:answers) { create_list(:answer, 4, question: question, user: user) }
      let(:answer) { answers.first }
      let(:resource) { answer }
      let(:resource_response) { answer_response }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorizable'

      it_behaves_like 'API returns all public fields' do
        let(:public_fields) { %w[id body created_at updated_at] }
      end

      it_behaves_like 'API returns list of resource' do
        let(:resource_contents) { %w[id body] }
      end
    end
  end

  describe 'GET /api/v1/questions/:id/answers/:id' do
    let(:user) { create :user }
    let(:method) { :get }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, :with_files ,question: question, user: user) } 
    let!(:link) { create :link, linkable: answer, name: 'stackoverflow', url: 'https://stackoverflow.com' }
    let!(:comment) {create :comment, commentable: answer, user: user}
    
    it_behaves_like 'API Unauthorizable'

    context 'authorized' do
      let(:answer_response) { json['answer'] }
      let(:resource) { answer }
      let(:resource_response) { answer_response }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorizable'

      it_behaves_like 'API returns all public fields' do
        let(:public_fields) { %w[id body created_at updated_at] }
      end

      it_behaves_like 'API returns list of resource' do
        let(:resource_contents) { %w[comments files links] }
      end

      context 'answer links' do
        it_behaves_like 'API returns all public fields' do
          let(:resource) { answer.links.first }
          let(:resource_response) { answer_response['links'].first }
          let(:public_fields) { %w[id name url created_at updated_at] }
        end
      end

      context 'answer comments' do
        it_behaves_like 'API returns all public fields' do
          let(:resource) { answer.comments.first }
          let(:resource_response) { answer_response['comments'].first }
          let(:public_fields) { %w[id body user_id created_at updated_at] }
        end
      end

      it 'contains files' do
        expect(answer_response['files'].first['url']).to eq Rails.application.routes.url_helpers.rails_blob_path(answer.files.first, only_path: true)
      end
    end
  end

  describe 'POST /api/v1/answers' do
    let(:user) { create :user }
    let!(:question) { create(:question, user: user) }
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Unauthorizable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:answer) { attributes_for(:answer, user: user, question: question) }
        let(:answer_response) { json['answer'] }

        before do
          post api_path,
               params: { access_token: access_token.token, answer: answer },
               headers: headers
        end

        it 'creates a new Answer' do
          expect do 
            post api_path, params: { access_token: access_token.token, answer: answer }, headers: headers
          end.to change(Answer, :count).by(1)
        end

        it_behaves_like 'API Authorizable'

        it 'contains user object' do
          expect(answer_response['user']['id']).to eq access_token.resource_owner_id
        end

        it 'creates a answer with the correct attributes' do
          expect(Answer.last).to have_attributes answer
        end
      end

      context 'with invalid attributes' do
        let(:answer) { attributes_for(:answer, :invalid, question: question) }

        before do
          post api_path, params: { access_token: access_token.token, answer: answer }, headers: headers
        end

        it "doesn't save answer, renders errors" do
          expect do 
            post api_path, params: { access_token: access_token.token, answer: answer }, headers: headers
          end.to_not change(Answer, :count)
        end

        it 'returns status 422' do
          expect(response.status).to eq 422
        end

        it 'returns error' do
          expect(json['errors']).to_not be_nil
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create :user }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }
    let!(:answer) { create(:answer, question: question, user: user) } 
    let!(:link) { create :link, linkable: answer, name: 'stackoverflow', url: 'https://stackoverflow.com' }
    let!(:comment) {create :comment, commentable: answer, user: user}
    let(:method) { :patch }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Unauthorizable'

    context 'authorized' do
      context 'author' do
        context 'with valid attributes' do
          let(:answer_response) { json['answer'] }

          before do
            patch api_path,
              params: { access_token: access_token.token, answer: { body: 'new body' } }, headers: headers
          end

          it_behaves_like 'API Authorizable'

          it 'contains user object' do
            expect(answer_response['user']['id']).to eq access_token.resource_owner_id
          end

          it 'changes answer attributes' do
            answer.reload
            expect(answer.body).to eq 'new body'
          end
        end

        context 'with invalid attributes' do
          before do
            patch api_path, params: { access_token: access_token.token, answer: { body: '' } }, headers: headers
          end

          it 'does not change answer' do
            answer.reload

            expect(answer.body).to eq answer.body
          end

          it 'returns status 422' do
            expect(response.status).to eq 422
          end

          it 'returns error' do
            expect(json['errors']).to_not be_nil
          end
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create :user }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Unauthorizable'

    context 'authorized' do
      context 'author' do
        it 'deletes the answer' do
          expect do
            delete api_path, params: { access_token: access_token.token, headers: headers }
          end.to change(Answer, :count).by(-1)
        end

        it 'returns 200 status' do
          delete api_path, params: { access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        it 'returns deleted answer json' do
          delete api_path, params: { access_token: access_token.token }, headers: headers
          %w[id body created_at updated_at].each do |attr|
            expect(json['answer'][attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end
