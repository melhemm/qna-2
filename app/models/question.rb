class Question < ApplicationRecord
  include Votable
  
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  
  has_one :award, dependent: :destroy

  has_many_attached :files

  belongs_to :user, class_name: 'User'

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true
  validates :body, presence: :true
end
