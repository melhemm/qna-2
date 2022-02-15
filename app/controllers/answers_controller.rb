class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_answer,  only: %i[show update destroy]
  before_action :set_question, only: %i[create]

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
    if current_user&.author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'answer deleted'
    else
      redirect_to question_path(@answer.question)
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body)
  end
end
