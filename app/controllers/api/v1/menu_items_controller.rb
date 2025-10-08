# frozen_string_literal: true

class Api::V1::MenuItemsController < Api::V1::ApplicationController
  before_action :set_restaurant
  before_action :set_menu

  def index
    @menu_associations = @menu.menu_associations.includes(:menu_item).page(params[:page] || 1).per(params[:per_page] || 10)
  end

  private
    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def set_menu
      @menu = @restaurant.menus.find(params[:menu_id])
    end
end
