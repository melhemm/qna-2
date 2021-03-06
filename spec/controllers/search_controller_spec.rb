require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    %w(All Questions Answers Comments Users).each do |search_object|
      it "calls search for #{search_object}" do
        expect(Search).to receive(:search_results).with('text text text', search_object)
        get :index, params: { search_text: 'text text text' }.merge(search_object: search_object)
      end
    end

    it 'renders index template' do
      expect(response).to render_template("index")
    end

    it 'redirects to root_path if empty or not result' do
      get :index, params: { search_text: '' }
      expect(response).to redirect_to root_path
    end
  end
end
