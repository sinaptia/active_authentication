require "test_helper"
require "generators/pauth/views/views_generator"

class Pauth::ViewsGeneratorTest < Rails::Generators::TestCase
  tests Pauth::ViewsGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  test "copies all views if no views are specified" do
    run_generator

    %w[confirmations passwords registrations sessions].each do |directory|
      assert_directory "app/views/pauth/#{directory}"
    end
  end

  test "copies specified views" do
    run_generator %w[-v sessions]

    assert_directory "app/views/pauth/sessions"

    %w[confirmations passwords registrations].each do |directory|
      assert_no_directory "app/views/pauth/#{directory}"
    end
  end
end
