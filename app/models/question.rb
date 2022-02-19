class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  has_many_attached :files

  belongs_to :user, class_name: 'User'

  validates :title, :body, presence: true
  validates :body, presence: :true
end
