# frozen_string_literal: true

class Api::V1::MenuImportsController < Api::V1::ApplicationController
  def create
    file_path = file.tempfile.path

    @menu_import = MenuImport.new(file_path: file_path)

    if @menu_import.import
      render json: @menu_import.logs.map(&:to_h), status: :ok
    else
      render json: { errors: @menu_import.errors }, status: :unprocessable_entity
    end
  end

  private

  def file
    params.expect(:file)
  end
end
