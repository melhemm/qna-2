require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    let(:do_request) { post :create, params: { question_id: question, user: user }, format: :js }

    context 'authenticated user' do
      before { sign_in(user) }

      it 'saves a new user\'s subscription in database' do
        expect { do_request }.to change(user.subscriptions, :count).by(1)
      end

      it 'saves a new question\'s subscription in database' do
        expect { do_request }.to change(question.subscriptions, :count).by(1)
      end

      it 'render create template' do
        do_request
        expect(response).to render_template :create
      end
    end

    context 'unauthenticated user' do
      it 'does not save the subscription' do
        expect { do_request }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create :subscription, user: user, question: question }
    let(:guest) { create(:user) }
    let(:do_request) { delete :destroy, params: { id: subscription }, format: :js }

    context 'User want to remove his subscription' do
      before { sign_in(user) }

      it 'destroy subscription' do
        expect { do_request }.to change(question.subscriptions, :count).by(-1)
      end

      it 'render destroy template' do
        do_request
        expect(response).to render_template :destroy
      end
    end

    context 'User want to delete not his subscription' do
      before { sign_in(guest) }

      it 'does not delete subscription' do
        expect { do_request }.to_not change(question.subscriptions, :count)
      end
    end
  end
end
