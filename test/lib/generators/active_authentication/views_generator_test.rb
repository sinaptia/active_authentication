require "test_helper"
require "generators/active_authentication/views/views_generator"

class ActiveAuthentication::ViewsGeneratorTest < Rails::Generators::TestCase
  tests ActiveAuthentication::ViewsGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  test "copies all views if no views are specified" do
    run_generator

    %w[confirmations passwords registrations sessions].each do |directory|
      assert_directory "app/views/active_authentication/#{directory}"
    end
  end

  test "copies specified views" do
    run_generator %w[-v sessions]

    assert_directory "app/views/active_authentication/sessions"

    %w[confirmations passwords registrations].each do |directory|
      assert_no_directory "app/views/active_authentication/#{directory}"
    end
  end
end
