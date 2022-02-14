class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user, class_name: 'User'

  validates :title, :body, presence: true
  validates :body, presence: :true
end
