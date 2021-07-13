class RoutesController < ApplicationController
  before_action :set_routes

  def index
    origins = @routes.distinct(:from).pluck(:from)
    origins_json = origins.map { |o| { type: :origins, id: o } }
    render json: { data: origins_json }
  end

  def show
    routes = @routes.distinct.where(**route_params.to_h).order(price: :asc) #Ordering from lowest to highest
    data = routes.map(&:to_jsonapi)
    if route_params.to_h.length == 1 || data.length == 0 
      render json: { data: data } 
    else 
      render json: { data: data.first } 
    end
  end

  def route_params
    params.permit(:from, :to, :airline) #adding the filter per airline
  end

  def set_routes
    @routes = CheapRoute.where(created_at: 10.hours.ago..1.second.ago)
  end
end
