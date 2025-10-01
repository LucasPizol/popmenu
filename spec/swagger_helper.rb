# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require File.expand_path('../config/environment', __dir__)
require 'database_cleaner'
require 'rspec/rails'
require 'spec_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s
  config.swagger_dry_run = false

  config.openapi_specs = {
    'api/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Backend PopMenu API',
        version: 'v1'
      }
    }
  }

  config.openapi_format = :yaml
end
