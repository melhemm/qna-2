class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :set_commentable, only: %i[create @commentable]
  after_action :publish_comment, only: :create

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.new(commentable_params.merge(user: current_user))
    @comment.save
  end

  private

  def commentable_name
    params[:commentable]
  end

  def commentable_id
    "#{commentable_name}_id".to_sym
  end

  def set_commentable
    @commentable = commentable_name.classify.constantize.find(params[commentable_id])
  end

  def commentable_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "comments/question-#{@commentable.is_a?(Question) ? @commentable.id : @commentable.question.id}",
      comment: @comment
    )
  end
  
end
