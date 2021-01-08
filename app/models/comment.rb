class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 100 }

end
