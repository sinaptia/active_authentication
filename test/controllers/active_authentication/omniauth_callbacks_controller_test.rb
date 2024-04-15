require "test_helper"

class ActiveAuthentication::OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  def omniauth_hash(email)
    {
      "provider" => "developer",
      "uid" => "test",
      "auth_data" => {},
      "info" => {
        "email" => email
      }
    }
  end

  test "authenticated users that have a third party account linked will remain signed in" do
    user = users :patricio
    user.authentications.create provider: :developer, uid: "test"
    sign_in user

    assert_no_changes -> { Authentication.count } do
      get omniauth_callback_path(provider: :developer), env: { "omniauth.auth" => omniauth_hash(user.email) }
    end

    assert_equal user.id, session[:user_id]
    assert_redirected_to root_path
  end

  test "authenticated users that don't have a third party account linked will have their third party account linked and sign in" do
    user = users :patricio
    sign_in user

    assert_changes -> { Authentication.count } do
      get omniauth_callback_path(provider: :developer), env: { "omniauth.auth" => omniauth_hash(user.email) }
    end

    assert_equal user.id, session[:user_id]
    assert_redirected_to root_path
  end

  test "unauthenticated users that don't have an account can create an account with a third party account and sign in" do
    assert_changes -> { User.count } do
      assert_changes -> { Authentication.count } do
        get omniauth_callback_path(provider: :developer), env: { "omniauth.auth" => omniauth_hash("test@example.com") }
      end
    end

    assert_equal User.last.id, session[:user_id]
    assert_redirected_to root_path
  end

  test "unauthenticated users that have an account can sign in with their third party account" do
    user = users :patricio
    user.authentications.create provider: :developer, uid: "test"

    get omniauth_callback_path(provider: :developer), env: { "omniauth.auth" => omniauth_hash(user.email) }

    assert_equal user.id, session[:user_id]
    assert_redirected_to root_path
  end
end
