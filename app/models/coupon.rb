class Coupon < ApplicationRecord
  belongs_to :user

  enum is_valid: { '有効': true, '無効': false }

  attachment :image

end
