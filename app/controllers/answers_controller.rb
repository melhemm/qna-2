class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_answer,  only: %i[show update destroy best]
  before_action :set_question, only: %i[create]

  after_action :publish_answer, only: :create

  authorize_resource
  
  include Voted

  def index; end

  def show; end

  def new; end

  def create
    @answer = @question.answers.new(answers_params)
    @answer.user = current_user
    @answer.save
  end

  def edit; end

  def update
    @answer.update(answers_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
    flash[:notice] = 'Answer successfully deleted.'
  end

  def best
    if current_user.author?(@answer.question)
      @answer.best!
    else
      redirect_to @answer.question
    end
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body, 
                                  files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{@answer.question_id}",
      answer: @answer
    )
  end
  
end
