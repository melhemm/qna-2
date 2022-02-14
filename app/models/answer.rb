class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user, class_name: 'User'

  validates :body, presence: true
end