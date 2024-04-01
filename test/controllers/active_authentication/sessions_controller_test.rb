require "test_helper"

class ActiveAuthentication::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated users should GET /sessions/new" do
    get new_session_path
    assert_response :success
  end

  test "authenticated users shouldn't GET /sessions/new" do
    sign_in users(:patricio)

    get new_session_path
    assert_redirected_to root_path
  end

  test "unauthenticated users should create a new session if credentials are valid" do
    user = users :patricio

    post session_path, params: {email: user.email, password: "password"}

    assert_redirected_to root_path
    assert_equal user.id, session[:user_id]
  end

  test "the lockable concern prevents an unauthenticated user from signing in if they are locked" do
    user = users :patricio
    user.lock

    post session_path, params: {email: user.email, password: "password"}

    assert_response :unprocessable_entity
  end

  test "the trackable concern tracks the user" do
    user = users :patricio

    assert_changes -> { user.reload.sign_in_count } do
      post session_path, params: {email: user.email, password: "password"}
    end

    assert_redirected_to root_path
    assert_equal user.id, session[:user_id]
  end

  test "unauthenticated users shouldn't create a new session if credentials are invalid" do
    post session_path, params: {email: users(:patricio).email, password: "123"}

    assert_response :unprocessable_entity
  end

  test "authenticated users shouldn't create a new session if credentials are valid" do
    user = users :patricio

    sign_in user

    post session_path, params: {email: user.email, password: "password"}
    assert_redirected_to root_path
  end

  test "unauthenticated users shouldn't destroy a session" do
    delete session_path
    assert_redirected_to new_session_path
  end

  test "authenticated users should destroy a session" do
    sign_in users(:patricio)

    delete session_path
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end
end
