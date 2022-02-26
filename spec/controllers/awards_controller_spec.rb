require 'rails_helper'

RSpec.describe AwardsController, type: :controller do

  describe 'GET #index' do
    let(:user) { create :user }
    let!(:question) { create :question, user: user }
    let!(:awards) { create_list(:award, 1, :with_image, question: question, user: user) }

    before do
      login(user)
      get :index
    end

    it 'assigns awards to @awards' do
      expect(assigns(:awards)).to eq awards
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
