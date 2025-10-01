# frozen_string_literal: true

class Api::V1::MenusController < Api::V1::ApplicationController
  before_action :set_menu

  def index
    @menus = Menu.select(:id, :name, :created_at, :updated_at)
                 .order(:created_at)
                 .page(params[:page] || 1)
                 .per(params[:per_page] || 10)
  end

  def show; end

  private
    def set_menu
      @menu = Menu.find(params[:id])
    end
end
