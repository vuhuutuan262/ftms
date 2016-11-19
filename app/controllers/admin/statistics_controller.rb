class Admin::StatisticsController < ApplicationController
  load_and_authorize_resource class: false
  skip_load_resource only: :create

  include FilterData

  before_action :load_locations, only: :show
  before_action :load_statistic_view
  before_action :load_filter, only: :show

  def show
    add_breadcrumb_index "statistics"
    @filter_data_user = @filter_service.user_filter_data
    template = "admin/statistics/#{params[:type]}"
    if template_exists? template
      render template
    else
      raise ActionController::RoutingError.new "Not Found"
    end
  end

  def create
    respond_to do |format|
      format.js
    end
  end

  private
  def load_locations
    @locations = Location.includes profiles: :user_type
  end

  def load_statistic_view
    start_date = params[:start_date] ? params[:start_date].to_date : Date.today.beginning_of_year
    location_ids = params[:location_ids]
    end_date = params[:end_date] ? params[:end_date].to_date : Date.today
    stage_ids = params[:stage_ids] ? params[:stage_ids] : Stage.all.map(&:id)
    @statistics = Supports::Statistic.new location_ids: location_ids,
      start_date: start_date, end_date: end_date, stage_ids: stage_ids
  end
end
