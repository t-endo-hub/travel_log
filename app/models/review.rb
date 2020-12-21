class Review < ApplicationRecord
  belongs_to :user
  belongs_to :tourist_spot

  attachment :review_image

end
