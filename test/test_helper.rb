# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

# for fixtures
require "bcrypt"

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths = [File.expand_path("fixtures", __dir__)]
  ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActionMailer::TestCase.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActiveSupport::TestCase.file_fixture_path = File.expand_path("fixtures", __dir__) + "/files"
  ActiveSupport::TestCase.fixtures :all
end

class ActionDispatch::IntegrationTest
  include ActiveAuthentication::Test::Helpers
end

class Rails::Generators::TestCase
  private

  def copy_routes
    routes_dir = File.expand_path "config", destination_root
    routes = File.expand_path routes_dir, "routes.rb"

    FileUtils.mkdir routes_dir
    FileUtils.cp Rails.root.join("config/routes.rb"), routes
  end
end
