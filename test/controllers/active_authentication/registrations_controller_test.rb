require "test_helper"

class ActiveAuthentication::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated users should GET /registrations/new" do
    get new_registration_path

    assert_response :success
  end

  test "authenticated users shouldn't GET /registrations/new" do
    sign_in users(:patricio)

    get new_registration_path

    assert_redirected_to root_path
  end

  test "unauthenticated users should create a new user if params are valid" do
    assert_changes "User.count" do
      post registrations_path, params: {user: {email: "test@example.com", password: "password", password_confirmation: "password"}}
    end
    assert_redirected_to root_path
  end

  test "unauthenticated users shouldn't create a new user if the email has been taken" do
    assert_no_changes "User.count" do
      post registrations_path, params: {user: {email: users(:patricio).email, password: "password", password_confirmation: "password"}}
    end
    assert_response :unprocessable_entity
  end

  test "unauthenticated users shouldn't create a new user if the passwords don't match" do
    assert_no_changes "User.count" do
      post registrations_path, params: {user: {email: "test@example.com", password: "password", password_confirmation: "wordpass"}}
    end
    assert_response :unprocessable_entity
  end

  test "unauthenticated users should create a new user if params are valid, with custom #registration_params" do
    ActiveAuthentication.configure do |config|
      config.registration_params = ->(controller) {
        controller.params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      }
    end

    assert_changes "User.count" do
      post registrations_path, params: {user: {first_name: "Patricio", last_name: "Mac Adden", email: "test@example.com", password: "password", password_confirmation: "password"}}
    end

    user = User.last

    assert_equal "Patricio", user.first_name
    assert_equal "Mac Adden", user.last_name

    assert_redirected_to root_path
  end

  test "unauthenticated users shouldn't GET /profile/edit" do
    get edit_profile_path
    assert_redirected_to new_session_path
  end

  test "authenticated users should GET /profile/edit" do
    sign_in users(:patricio)

    get edit_profile_path

    assert_response :success
  end

  test "unauthenticated users shouldn't update a profile" do
    put profile_path, params: {user: {email: users(:patricio).email}}

    assert_redirected_to new_session_path
  end

  # TODO: the following test takes into account that the confirmable concern is also included.
  # It'd be nice to add test this independently of the confirmable concern.

  test "authenticated users should update their profile" do
    user = users :patricio
    sign_in user

    assert_changes -> { user.reload.unconfirmed_email } do
      put profile_path, params: {user: {email: "test@example.com"}}
    end

    assert_redirected_to edit_profile_path
  end

  test "authenticated users shouldn't update their profile if their new password and password confirmation don't match" do
    user = users :patricio
    sign_in user

    assert_no_changes -> { user.reload.unconfirmed_email } do
      put profile_path, params: {user: {email: user.email, password: "password", password_confirmation: "wordpass"}}
    end

    assert_response :unprocessable_entity
  end

  test "authenticated users should update their profile, with custom #profile_params" do
    ActiveAuthentication.configure do |config|
      config.profile_params = ->(controller) {
        controller.params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      }
    end

    user = users :patricio
    sign_in user

    assert_changes -> { user.reload.first_name }, to: "Patricio" do
      assert_changes -> { user.reload.last_name }, to: "Mac Adden" do
        put profile_path, params: {user: {first_name: "Patricio", last_name: "Mac Adden"}}
      end
    end

    assert_redirected_to edit_profile_path
  end

  test "unauthenticated users shouldn't destroy a profile" do
    assert_no_changes "User.count" do
      delete profile_path
    end
    assert_redirected_to new_session_path
  end

  test "authenticated users should destroy a profile" do
    sign_in users(:patricio)

    assert_changes "User.count" do
      delete profile_path
    end
    assert_redirected_to root_path
  end
end
