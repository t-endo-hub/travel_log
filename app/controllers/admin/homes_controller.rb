class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    days = (Date.today.beginning_of_month..Date.today).to_a
    users = days.map { |item| User.where(:created_at => item.beginning_of_day..item.end_of_day).count }
    @graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーザー月間登録推移')
      f.xAxis(categories: days)
      f.series(name: '登録数', data: users)
    end
  end
end
