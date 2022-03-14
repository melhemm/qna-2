class User < ApplicationRecord
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, 
         :omniauthable, omniauth_providers: %i(github vkontakte)

  has_many :questions, dependent: :destroy, foreign_key: :user_id
  has_many :answers, dependent: :destroy, foreign_key: :user_id
  has_many :awards, dependent: :destroy, foreign_key: :user_id
  has_many :votes, dependent: :destroy, foreign_key: :user_id
  has_many :comments, dependent: :destroy, foreign_key: :user_id

  def author?(author)
    author.user_id == id
  end

  def voted?(resource)
    votes.where(votable: resource).present?
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
  
end
