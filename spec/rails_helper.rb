# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter(/^\/lib\/generators\//)
  end
end

require_relative 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path(
  'fixtures/rails_app/config/environment', __dir__
)
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].sort.each do |file|
  require file
end

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migrator.migrations_paths = 'spec/fixtures/rails_app/db/migrate'
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.fixture_path = Rails.root.join('spec', 'fixtures').to_s
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

Rails.application.eager_load! if ENV['COVERAGE']
