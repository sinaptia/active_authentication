require "test_helper"
require "generators/active_authentication/omniauthable/omniauthable_generator"

class ActiveAuthentication::OmniauthableGeneratorTest < Rails::Generators::TestCase
  tests ActiveAuthentication::OmniauthableGenerator
  destination Rails.root.join("tmp/generators")

  setup do
    prepare_destination
    copy_routes
  end

  test "generates an Authentication model" do
    run_generator

    assert_file "app/models/authentication.rb"
  end
end
