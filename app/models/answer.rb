class Answer < ApplicationRecord
  include Votable
  
  belongs_to :question
  belongs_to :user, class_name: 'User'

  has_many_attached :files

  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, dependent: :destroy, as: :commentable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  default_scope -> { order('best DESC, created_at') }
  
  scope :best, -> { where(best: true) }

  def best!
    transaction do
      question.answers.best.update_all(best: false)
      update!(best: true)
      question.award&.update!(user: user)
    end
  end
end
