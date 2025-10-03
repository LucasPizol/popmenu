# frozen_string_literal = true

class Api::V1::RestaurantsController < Api::V1::ApplicationController
  before_action :set_restaurant, only: [ :show, :update, :destroy ]

  def index
    @restaurants = Restaurant.select(:id, :name, :created_at, :updated_at)
                             .order(:created_at)
                             .page(params[:page] || 1)
                             .per(params[:per_page] || 10)
  end

  def show; end

  def create
    @restaurant = Restaurant.new(restaurant_params)

    if @restaurant.save
      render :show, status: :created
    else
      render json: { errors: @restaurant.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @restaurant.update(restaurant_params)
      render :show, status: :ok
    else
      render json: { errors: @restaurant.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @restaurant.destroy
    head :no_content
  end

  private
    def restaurant_params
      params.require(:restaurant).permit(:name, :description)
    end

    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end
end
