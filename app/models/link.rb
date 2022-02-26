class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, presence: true, url: true

  def gist_link?
    url.include?('https://gist.github.com')
  end
end
