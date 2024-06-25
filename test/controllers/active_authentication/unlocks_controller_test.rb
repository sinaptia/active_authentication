require "test_helper"

class ActiveAuthentication::UnlocksControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated users should GET /unlocks/new" do
    get new_unlock_path

    assert_response :success
  end

  test "authenticated users shouldn't GET /unlocks/new" do
    sign_in users(:patricio)

    get new_unlock_path

    assert_redirected_to root_path
  end

  test "unauthenticated users should receive an email to their email if they have an account" do
    user = users :patricio
    user.lock

    assert_emails 1 do
      post unlocks_path, params: {email: user.email}
    end
    assert_redirected_to root_path
  end

  test "unauthenticated users should not receive an email if they don't enter an email" do
    assert_no_emails do
      post unlocks_path, params: {email: ""}
    end
    assert_redirected_to root_path
  end

  test "unauthenticated users shouldn't receive an email if their account isn't locked" do
    assert_no_emails do
      post unlocks_path, params: {email: "test@example.com"}
    end
    assert_redirected_to root_path
  end

  test "authenticated users shouldn't receive an email" do
    user = users :patricio
    sign_in user

    assert_no_emails do
      post unlocks_path, params: {email: user.email}
    end
    assert_redirected_to root_path
  end

  test "unauthenticated users should unlock their account and be signed in if the token is valid" do
    user = users :patricio
    user.lock
    token = user.generate_token_for :unlock

    assert_changes -> { user.reload.locked_at }, to: nil do
      get unlock_path(token)
    end
    assert_equal user.id, session[:user_id]
    assert_redirected_to root_path
  end

  test "unauthenticated users shouldn't unlock their account and be signed in if the token is invalid" do
    get unlock_path("invalidtoken")

    assert_nil session[:user_id]
    assert_redirected_to root_path
  end

  test "unauthenticated users shouldn't unlock their account and be signed in if the token is expired" do
    user = users :patricio
    user.lock
    token = user.generate_token_for :unlock

    travel 2.days
    assert_no_changes -> { user.reload.locked_at } do
      get unlock_path(token)
    end
    assert_nil session[:user_id]
    assert_redirected_to root_path
  end

  test "authenticated users shouldn't unlock their account if the token is valid" do
    user = users :patricio
    sign_in user
    user.lock
    token = user.generate_token_for :unlock

    assert_no_changes -> { user.reload.locked_at } do
      get unlock_path(token)
    end
    assert_redirected_to root_path
  end

  test "authenticated users shouldn't unlock their account if the token is invalid" do
    user = users :patricio
    user.lock
    sign_in user

    assert_no_changes -> { user.reload.locked_at } do
      get unlock_path("invalidtoken")
    end
    assert_redirected_to root_path
  end

  test "authenticated users shouldn't unlock their account if the token is expired" do
    user = users :patricio
    user.lock
    sign_in user
    token = user.generate_token_for :unlock

    travel 2.days
    assert_no_changes -> { user.reload.locked_at } do
      get unlock_path(token)
    end
    assert_redirected_to root_path
  end
end
