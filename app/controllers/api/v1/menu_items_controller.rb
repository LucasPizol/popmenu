# frozen_string_literal: true

class Api::V1::MenuItemsController < Api::V1::ApplicationController
  before_action :set_restaurant
  before_action :set_menu

  def index
    @menu_items = @menu.menu_items.page(params[:page] || 1).per(params[:per_page] || 10)
  end

  private
    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def set_menu
      @menu = @restaurant.menus.find(params[:menu_id])
    end
end
