require "test_helper"

class ActiveAuthentication::PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated users should GET /passwords/new" do
    get new_password_path

    assert_response :success
  end

  test "authenticated users shouldn't GET /passwords/new" do
    sign_in users(:patricio)

    get new_password_path

    assert_redirected_to root_path
  end

  test "unauthenticated users should receive an email if they have an account" do
    assert_emails 1 do
      post passwords_path, params: {email: users(:patricio).email}
    end
    assert_redirected_to root_path
  end

  test "unauthenticated users should not receive an email if they don't enter an email" do
    assert_no_emails do
      post passwords_path, params: {email: ""}
    end
    assert_redirected_to root_path
  end

  test "unauthenticated users shouldn't receive an email if they don't have an account" do
    assert_no_emails do
      post passwords_path, params: {email: "test@example.com"}
    end
    assert_redirected_to root_path
  end

  test "authenticated users shouldn't receive an email" do
    user = users :patricio
    sign_in user

    assert_no_emails do
      post passwords_path, params: {email: user.email}
    end
    assert_redirected_to root_path
  end

  test "unauthenticated users should GET /passwords/:token/edit if the token is valid" do
    user = users :patricio
    token = user.generate_token_for :password_reset

    get edit_password_path(token)

    assert_response :success
  end

  test "unauthenticated users shouldn't GET /passwords/:token/edit if the token is invalid" do
    get edit_password_path("invalid_token")

    assert_redirected_to root_url
  end

  test "unauthenticated users shouldn't GET /passwords/:token/edit if the token is expired" do
    user = users :patricio
    token = user.generate_token_for :password_reset

    travel 2.hours
    get edit_password_path(token)

    assert_redirected_to root_url
  end

  test "authenticated users shouldn't GET /passwords/:token/edit if the token is valid" do
    user = users :patricio
    sign_in user
    token = user.generate_token_for :password_reset

    get edit_password_path(token)

    assert_redirected_to root_path
  end

  test "unauthenticated users should set a new password if password and password confirmation match and the token is valid" do
    user = users :patricio
    token = user.generate_token_for :password_reset

    put password_path(token), params: {user: {password: "password", password_confirmation: "password"}}

    assert_redirected_to root_path
    assert_equal user.id, session[:user_id]
  end

  test "unauthenticated users shouldn't set a new password if password and password confirmation don't match and the token is valid" do
    user = users :patricio
    token = user.generate_token_for :password_reset

    put password_path(token), params: {user: {password: "password", password_confirmation: "wordpass"}}

    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "unauthenticated users shouldn't set a new password if password and password confirmation match and the token is invalid" do
    user = users :patricio
    token = user.generate_token_for :password_reset

    travel 2.hours
    put password_path(token), params: {user: {password: "password", password_confirmation: "password"}}

    assert_redirected_to root_path
    assert_nil session[:user_id]
  end

  test "authenticated users shouldn't set a new password if password and password confirmation match and the token is valid" do
    user = users :patricio
    sign_in user
    token = user.generate_token_for :password_reset

    put password_path(token), params: {user: {password: "password", password_confirmation: "password"}}

    assert_redirected_to root_path
  end
end
