class SearchController < ApplicationController
  skip_authorization_check
  
  def index
    search_object = params[:search_object]
    search_text = params[:search_text]
    return redirect_to root_path if search_text.empty?
    @search_results = Search.search_results(search_text, search_object)
  end
end
