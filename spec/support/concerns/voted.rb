require 'rails_helper'

shared_examples_for 'voted' do
  let!(:author) { create(:user) }
  let!(:user) { create(:user) }
  let!(:vote) { create(:vote, votable: voted) }

  describe 'POST #vote' do
    context 'for not votable author' do
      before { login(user) }

      it 'send vote to database' do
        expect { post :vote, params: { id: voted, voted: { value: 1 }, format: :json } }.to change(Vote, :count).by(1)
      end

      it 'response json' do
        post :vote, params: { id: voted, voted: { value: 1 }, format: :json }
        expected = { votable_type: voted.class.to_s.downcase, votable_id: voted.id, rating: voted.rating }.to_json

        expect(response) == expected
      end
    end

    context 'for votable author' do
      before { login(author) }

      it 'err while voting' do
        expect { post :vote, params: { id: voted, voted: { value: 1 }, format: :json } }.to_not change(Vote, :count)
      end

      it 'response status 204' do
        post :vote, params: { id: voted, voted: { value: 1 }, format: :json }

        expect(response.status).to eq 204
      end
    end

    context 'Unauthorized member' do
      it 'vote err' do
        expect { post :vote, params: { id: voted, voted: { value: 1 }, format: :json } }.to_not change(Vote, :count)
      end

      it 'response status 401' do
        post :vote, params: { id: voted, voted: { value: 1 }, format: :json }

        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST #revote' do
    context 'vote for author' do
      before { login(vote.user) }

      it 'Remove vote for database' do
        expect { post :revote, params: { id: voted, format: :json } }.to change(Vote, :count).by(-1)
      end

      it 'response json' do
        post :revote, params: { id: voted, format: :json }
        expected = { votable_type: voted.class.to_s.downcase, votable_id: voted.id, rating: voted.rating }.to_json

        expect(response) == expected
      end
    end

    context 'vote for a member' do
      before { login(user) }

      it 'does not delete a vote from a database' do
        expect { post :revote, params: { id: voted, format: :json } }.to_not change(Vote, :count)
      end

      it 'response status 200' do
        post :revote, params: { id: voted, format: :json }
        expect(response.status).to eq 200
      end
    end

    context 'Unauthorized user' do
      it 'voting not available' do
        expect { post :revote, params: { id: voted, format: :json } }.to_not change(Vote, :count)
      end

      it 'response status 401' do
        post :revote, params: { id: voted, format: :json }
        expect(response.status).to eq 401
      end
    end
  end
end
