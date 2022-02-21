class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy

  has_many_attached :files

  belongs_to :user, class_name: 'User'

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true
  validates :body, presence: :true
end
