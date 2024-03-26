require "test_helper"
require "generators/pauth/install/install_generator"

class Pauth::InstallGeneratorTest < Rails::Generators::TestCase
  tests Pauth::InstallGenerator
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

  test "adds the pauth routes" do
    run_generator

    assert_file "config/routes.rb", /pauth/
  end

  test "generates an initializer" do
    run_generator

    assert_file "config/initializers/pauth.rb"
  end

  private

  def copy_routes
    routes_dir = File.expand_path "config", destination_root
    routes = File.expand_path routes_dir, "routes.rb"

    FileUtils.mkdir routes_dir
    FileUtils.cp Rails.root.join("config/routes.rb"), routes
  end
end
