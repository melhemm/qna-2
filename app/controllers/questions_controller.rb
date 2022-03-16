class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  after_action :publish_question, only: [:create]

  authorize_resource

  include Voted

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    gon.question_id = @question.id
  end

  def new
    @question = Question.new
    @question.links.new
    @question.award = Award.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question deleted'
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast( 
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: {question: @question}
      )
    )
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                      files: [],
                                      links_attributes: [:id, :name, :url, :_destroy],
                                      award_attributes: [:title, :image])
  end
end
