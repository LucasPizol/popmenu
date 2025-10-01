# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require 'swagger_helper'
require_relative '../config/environment'
require 'rspec/rails'
require 'database_cleaner'
require 'rspec/rails'
require 'shoulda/matchers'
require 'test_prof/recipes/rspec/let_it_be'

abort("The Rails environment is running in production mode!") if Rails.env.production?

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

ENV['RAILS_ENV'] = 'test'
Dir[Rails.root.join('spec/helpers/**/*.rb')].sort.each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |spec|
    DatabaseCleaner.cleaning { spec.run }
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.filter_run_excluding(broken: true)

  config.include(FactoryBot::Syntax::Methods)
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework(:rspec)
    with.library(:rails)
  end
end
