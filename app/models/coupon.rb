class Coupon < ApplicationRecord
  belongs_to :user

  enum is_valid: { '有効': true, '無効': false }

  attachment :image


  # クーポン作成
  def self.coupon_create(user)
    time = Time.now.to_i
    coupon = Coupon.new(
      user_id: user.id,
      limit: 1
    )
    coupon.save
  end

  # クーポン削除
  def self.coupon_destroy
    time = Time.now
    coupons = Coupon.all
    coupons.each do |coupon|
      # クーポンを作成してから24時間経過かつ、クーポンの状態が有効の場合は、無効に変更して保存する。
      if coupon.created_at + coupon.limit.minutes < time && coupon.is_valid == '有効'
        coupon.is_valid = '無効'
        coupon.save
      end
    end
  end


end
