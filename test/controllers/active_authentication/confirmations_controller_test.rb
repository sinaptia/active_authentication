require "test_helper"

class ActiveAuthentication::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated users should GET /confirmations/new" do
    get new_confirmation_path

    assert_response :success
  end

  test "authenticated users shouldn't GET /confirmations/new" do
    sign_in users(:patricio)

    get new_confirmation_path

    assert_redirected_to root_path
  end

  test "unauthenticated users should receive an email to their unconfirmed email if they have an account" do
    user = users :patricio
    user.update unconfirmed_email: "test@example.com"

    assert_emails 1 do
      post confirmations_path, params: {email: user.unconfirmed_email}
    end
    assert_redirected_to root_path
  end

  test "unauthenticated users should not receive an email if they don't enter an email" do
    assert_no_emails do
      post confirmations_path, params: {email: ""}
    end
    assert_redirected_to root_path
  end

  test "unauthenticated users shouldn't receive an email if they don't have an unconfirmed email" do
    assert_no_emails do
      post confirmations_path, params: {email: "test@example.com"}
    end
    assert_redirected_to root_path
  end

  test "authenticated users shouldn't receive an email" do
    user = users :patricio
    user.update unconfirmed_email: "test@example.com"
    sign_in user

    assert_no_emails do
      post confirmations_path, params: {email: user.unconfirmed_email}
    end
    assert_redirected_to root_path
  end

  test "unauthenticated users should confirm their email address and be signed in if the token is valid" do
    user = users :patricio
    user.update unconfirmed_email: "test@example.com"
    token = user.generate_token_for :email_confirmation

    assert_changes -> { user.reload.email }, to: "test@example.com" do
      get confirmation_path(token)
    end
    assert_equal user.id, session[:user_id]
    assert_redirected_to root_path
  end

  test "unauthenticated users shouldn't confirm their email address and be signed in if the token is invalid" do
    get confirmation_path("invalidtoken")

    assert_nil session[:user_id]
    assert_redirected_to root_path
  end

  test "unauthenticated users shouldn't confirm their email address and be signed in if the token is expired" do
    user = users :patricio
    user.update unconfirmed_email: "test@example.com"
    token = user.generate_token_for :email_confirmation

    travel 2.days
    assert_no_changes -> { user.reload.email } do
      get confirmation_path(token)
    end
    assert_nil session[:user_id]
    assert_redirected_to root_path
  end

  test "authenticated users should confirm their email address if the token is valid" do
    user = users :patricio
    sign_in user
    user.update unconfirmed_email: "test@example.com"
    token = user.generate_token_for :email_confirmation

    assert_changes -> { user.reload.email }, to: "test@example.com" do
      get confirmation_path(token)
    end
    assert_redirected_to root_path
  end

  test "authenticated users shouldn't confirm their email address if the token is invalid" do
    user = users :patricio
    sign_in user
    user.update unconfirmed_email: "test@example.com"

    assert_no_changes -> { user.reload.email } do
      get confirmation_path("invalidtoken")
    end
    assert_redirected_to root_path
  end

  test "authenticated users shouldn't confirm their email address if the token is expired" do
    user = users :patricio
    sign_in user
    user.update unconfirmed_email: "test@example.com"
    token = user.generate_token_for :email_confirmation

    travel 2.days
    assert_no_changes -> { user.reload.email } do
      get confirmation_path(token)
    end
    assert_redirected_to root_path
  end
end
