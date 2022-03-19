require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) {create(:access_token)}
      let!(:questions) { create_list(:question, 4, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 4, question: question, user: user) }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create :user }
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question, user: user) }
    let!(:link) { create :link, linkable: question, name: 'stackoverflow', url: 'https://stackoverflow.com' }
    let!(:comment) {create :comment, commentable: question, user: user}
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Unauthorizable'

    context 'authorized' do
      let(:resource) { question }
      let(:resource_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorizable'

      it_behaves_like 'API returns all public fields' do
        let(:public_fields) { %w[id title body created_at updated_at] }
      end
      
      it_behaves_like 'API contains object' do
        let(:objects) { %w[user award] }
      end

      it_behaves_like 'API returns list of resource' do
        let(:resource_contents) { %w[comments files links] }
      end

      context 'question links' do
        it_behaves_like 'API returns all public fields' do
          let(:resource) { question.links.first }
          let(:resource_response) { json['question']['links'].first }
          let(:public_fields) { %w[id name url created_at updated_at] }
        end
      end

      context 'question comments' do
        it_behaves_like 'API returns all public fields' do
          let(:resource) { question.comments.first }
          let(:resource_response) { json['question']['comments'].first }
          let(:public_fields) { %w[id body created_at updated_at] }
        end
      end

      it 'contains files url' do
        expect(json['question']['files'].first['url']).to eq Rails.application.routes.url_helpers.rails_blob_path(
          question.files.first, only_path: true
        )
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:method) { :post }
    let(:user) { create :user }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:api_path) { '/api/v1/questions' }
    
    it_behaves_like 'API Unauthorizable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:question) { attributes_for(:question, user: user) }
        let(:question_response) { json['question'] }

        before do
          post api_path, params: { access_token: access_token.token, question: question }, headers: headers
        end

        it 'creates a new Question' do
          expect do 
            post api_path, params: { access_token: access_token.token, question: question }, headers: headers
          end.to change(Question, :count).by(1)
        end

        it_behaves_like 'API Authorizable'
    
        it 'contains user object' do
          expect(question_response['user']['id']).to eq access_token.resource_owner_id
        end
  
        it 'creates a question with the correct attributes' do
          expect(Question.last).to have_attributes question
        end
      end
    
      context 'with invalid attributes' do
        let(:question) { attributes_for(:question, :invalid) }
    
        before do
          post api_path, params: { access_token: access_token.token, question: question }, headers: headers
        end

        it "doesn't save question, renders errors" do
          expect do 
            post api_path, params: { access_token: access_token.token, question: question }, headers: headers
          end.to_not change(Question, :count)
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
  

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create :user }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    describe 'author' do
      let(:user_access_token) { create(:access_token, resource_owner_id: question.user.id) }

      context 'update with valid attributes' do
        before { patch api_path, params: { access_token: user_access_token.token, question: { body: 'New body' } }, headers: headers  }

        it_should_behave_like 'API ok status'

        it 'returns modified question fields ' do
          %w[id title body created_at updated_at files links comments].each do |attr|
            expect(json['question'].has_key?(attr)).to be_truthy
          end
        end

        it 'verifies that questions body was updated' do
          expect(json['question']['body']).to eq 'New body'
        end
      end

      context 'update with invalid attributes' do
        before { patch api_path, params: { access_token: user_access_token.token, question: { title: nil } }, headers: headers  }

        it 'returns unprocessable status' do
          expect(response).to be_unprocessable
        end

        it 'returns error for title' do
          expect(json.has_key?('title')).to be_truthy
        end

        it 'verifies that questions body was not change' do
          question.reload
          expect(question.body).to eq 'MyText'
        end
      end

      context 'unable to edit another users question' do
        before { put api_path, params: { access_token: access_token.token, question: { body: 'Edit' } }, headers: headers  }
        it 'returns forbidden status' do
          expect(response).to be_forbidden
        end
      end
    end
  end 

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create :user }
    let!(:question) { create(:question, user: user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Unauthorizable'

    context 'authorized' do
      context 'author' do
        it 'deletes the question' do
          expect do
            delete api_path, params: { access_token: access_token.token, headers: headers }
          end.to change(Question, :count).by(-1)
        end

        it 'returns 200 status' do
          delete api_path, params: { access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        it 'returns deleted question json' do
          delete api_path, params: { access_token: access_token.token }, headers: headers

          %w[id title body created_at updated_at].each do |attr|
            expect(json['question'][attr]).to eq question.send(attr).as_json
          end
        end
      end
    end
  end
end
