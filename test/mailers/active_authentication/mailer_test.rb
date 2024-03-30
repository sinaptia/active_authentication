require "test_helper"

class ActiveAuthentication::MailerTest < ActionMailer::TestCase
  test "email_confirmation_instructions" do
    user = users :patricio
    user.update unconfirmed_email: "test@example.com"

    mail = ActiveAuthentication::Mailer.with(token: "test-token", user: user).email_confirmation_instructions

    assert_equal [user.unconfirmed_email], mail.to
  end

  test "password_reset_instructions" do
    user = users :patricio

    mail = ActiveAuthentication::Mailer.with(token: "test-token", user: user).password_reset_instructions

    assert_equal [user.email], mail.to
  end

  test "unlock_instructions" do
    user = users :patricio

    mail = ActiveAuthentication::Mailer.with(token: "test-token", user: user).unlock_instructions

    assert_equal [user.email], mail.to
  end
end
