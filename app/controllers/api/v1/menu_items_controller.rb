# frozen_string_literal: true

class Api::V1::MenuItemsController < Api::V1::ApplicationController
  before_action :set_menu
  before_action :set_menu_item, only: [ :show ]

  def index
    @menu_items = @menu.menu_items.page(params[:page] || 1).per(params[:per_page] || 10)
  end

  def show; end

  private
    def set_menu
      @menu = Menu.find(params[:menu_id])
    end

    def set_menu_item
      @menu_item = @menu.menu_items.find(params[:id])
    end
end
