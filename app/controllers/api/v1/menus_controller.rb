# frozen_string_literal: true

class Api::V1::MenusController < Api::V1::ApplicationController
  before_action :set_restaurant
  before_action :set_menu, only: [ :show ]

  def index
    @menus = @restaurant.menus
                        .select(:id, :name, :restaurant_id, :created_at, :updated_at)
                        .order(:created_at)
                        .page(params[:page] || 1)
                        .per(params[:per_page] || 10)
  end

  def show; end

  private
    def set_menu
      @menu = @restaurant.menus.find(params[:id])
    end

    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    end
end
