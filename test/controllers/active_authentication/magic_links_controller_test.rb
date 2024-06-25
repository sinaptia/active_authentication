require "test_helper"

class ActiveAuthentication::MagicLinksControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated users should GET /magic_links/new" do
    get new_magic_link_path

    assert_response :success
  end

  test "authenticated users shouldn't GET /magic_links/new" do
    sign_in users(:patricio)

    get new_magic_link_path

    assert_redirected_to root_path
  end

  test "unauthenticated users should receive an email to their email if they have an account" do
    user = users :patricio

    assert_emails 1 do
      post magic_links_path, params: {email: user.email}
    end
    assert_redirected_to root_path
  end

  test "unauthenticated users should not receive an email if they don't enter an email" do
    assert_no_emails do
      post magic_links_path, params: {email: ""}
    end
    assert_redirected_to root_path
  end

  test "unauthenticated users shouldn't receive an email if they don't have an account" do
    assert_no_emails do
      post magic_links_path, params: {email: "test@example.com"}
    end
    assert_redirected_to root_path
  end

  test "unauthenticated users should sign in with the magic link" do
    user = users :patricio
    token = user.generate_token_for :magic_link

    get magic_link_path(token)

    assert_equal user.id, session[:user_id]
    assert_redirected_to root_path
  end

  test "unauthenticated users shouldn't sign in if the magic link token is expired" do
    user = users :patricio
    token = user.generate_token_for :magic_link

    travel 2.days
    get magic_link_path(token)

    assert_nil session[:user_id]
    assert_redirected_to root_path
  end
end
