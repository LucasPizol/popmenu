# frozen_string_literal: true

class MenuImport::Factory
  def initialize(file_path)
    @file_path = file_path
  end

  def create_strategy
    build_strategy
  rescue NameError
    raise "Invalid file type: #{file_extension}"
  end

  private

  attr_reader :file_path

  def build_strategy
    "MenuImport::Strategies::#{file_extension.capitalize}Strategy".constantize.new(file_path)
  end

  def file_extension
    @file_extension ||= @file_path.split(".").last
  end
end
