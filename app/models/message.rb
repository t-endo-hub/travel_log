class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  has_many :notifications, dependent: :destroy

  validates :body, presence: true, length: { maximum: 200 }

end
