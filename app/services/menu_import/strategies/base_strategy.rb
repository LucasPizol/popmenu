# frozen_string_literal: true

class MenuImport::Strategies::BaseStrategy
  def initialize(file_path)
    @file_path = file_path
  end

  def import
    raise NotImplementedError
  end

  protected

  attr_reader :file_path

  def file_content
    @file_content ||= File.read(file_path)
  end
end
