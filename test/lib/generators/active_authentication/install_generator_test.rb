require "test_helper"
require "generators/active_authentication/install/install_generator"

class ActiveAuthentication::InstallGeneratorTest < Rails::Generators::TestCase
  tests ActiveAuthentication::InstallGenerator
  destination Rails.root.join("tmp/generators")

  setup do
    prepare_destination
    copy_routes
  end

  test "generates a User model" do
    run_generator

    assert_file "app/models/user.rb"
  end

  test "generates a migration for the User model" do
    run_generator

    assert_migration "db/migrate/create_users.rb"
  end

  test "adds the active_authentication routes" do
    run_generator

    assert_file "config/routes.rb", /active_authentication/
  end

  test "generates an initializer" do
    run_generator

    assert_file "config/initializers/active_authentication.rb"
  end

  private

  def copy_routes
    routes_dir = File.expand_path "config", destination_root
    routes = File.expand_path routes_dir, "routes.rb"

    FileUtils.mkdir routes_dir
    FileUtils.cp Rails.root.join("config/routes.rb"), routes
  end
end
