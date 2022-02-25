class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy, foreign_key: :user_id
  has_many :answers, dependent: :destroy, foreign_key: :user_id
  has_many :awards, dependent: :destroy, foreign_key: :user_id

  def author?(author)
    author.user_id == id
  end
end
