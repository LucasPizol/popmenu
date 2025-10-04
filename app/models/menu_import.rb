# frozen_string_literal: true

class MenuImport
  include ActiveModel::Model
  include ActiveModel::Attributes

  VALID_FILE_TYPES = %w[json].freeze

  attribute :file_path, :string

  validates :file_path, presence: true
  validate :validate_file_type

  def import
    if valid?
      factory.create_strategy.import
    end
  end

  private

  def validate_file_type
    unless file_path.split(".").last.in?(VALID_FILE_TYPES)
      errors.add(:file_path, "must be a valid file type")
    end
  end

  def factory
    @factory ||= MenuImport::Factory.new(file_path)
  end
end
