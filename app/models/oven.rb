class Oven < ActiveRecord::Base
  belongs_to :user
  # account for more mutiple cookie
  has_many :cookies, as: :storage

  validates :user, presence: true
end
