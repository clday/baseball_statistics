class BattingStatisticsController < ApplicationController

  # GET /batting_statistics
  def index
    scope = BattingStatistic
    scope = scope.where(league: params[:league]) if params[:league].present?
    scope = scope.where(team_id: params[:team]) if params[:team].present?
    scope = scope.where(year: params[:season]) if params[:season].present?

    sort_by = params.fetch(:leader_type, 'batting_average')
    scope = scope.order(sort_by => :desc)

    @batting_statistics = scope.includes(:player).page(params[:page])
  end
end
