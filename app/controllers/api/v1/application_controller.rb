# frozen_string_literal: true

class Api::V1::ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private
    def not_found
      head :not_found
    end
end
