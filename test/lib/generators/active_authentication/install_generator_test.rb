require "test_helper"
require "generators/active_authentication/install/install_generator"

class ActiveAuthentication::InstallGeneratorTest < Rails::Generators::TestCase
  tests ActiveAuthentication::InstallGenerator
  destination Rails.root.join("tmp/generators")

  setup do
    prepare_destination
    copy_routes
  end

  test "generates a User model with all the concerns if no argument is passed" do
    run_generator

    assert_file "app/models/user.rb", /authenticates_with #{ActiveAuthentication::Model::CONCERNS.map { ":#{_1}" }.join(", ")}/
  end

  test "generates a User model with the given concerns if passed" do
    run_generator %w[confirmable lockable]

    assert_file "app/models/user.rb", /authenticates_with :confirmable, :lockable/
  end

  test "generates a migration for the User model" do
    run_generator

    assert_migration "db/migrate/create_users.rb"
  end

  test "generates a migration for the User model with the attributes of the unused concerns commented out" do
    run_generator %w[trackable]

    assert_migration "db/migrate/create_users.rb", /# t.string :unconfirmed_email/
    assert_migration "db/migrate/create_users.rb", /# t.integer :failed_attempts/
    assert_migration "db/migrate/create_users.rb", /# t.datetime :locked_at/
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
