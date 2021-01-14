class CouponsController < ApplicationController
  before_action :authenticate_user!

  def index
    @coupons = Coupon.where(user_id: current_user.id).where(is_valid: '有効').all
  end
end
