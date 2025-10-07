# frozen_string_literal: true

class MenuImport::Log
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :status, :string
  attribute :message, :string
  attribute :errors

  validates :status, presence: true
  validates :message, presence: true
  validates :errors, presence: true

  def to_h
    {
      status: status,
      message: message,
      errors: errors
    }
  end
end
