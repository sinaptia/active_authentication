# Preview all emails at http://localhost:3000/rails/mailers/active_authentication/mailer
class ActiveAuthentication::MailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/active_authentication/mailer/email_confirmation_instructions
  def email_confirmation_instructions
    user = User.create email: "patriciomacadden@gmail.com", password: "password", unconfirmed_email: "test@example.com"

    ActiveAuthentication::Mailer.with(token: "test-token", user: user).email_confirmation_instructions
  end

  # Preview this email at http://localhost:3000/rails/mailers/active_authentication/mailer/magic_link
  def magic_link
    user = User.create email: "patriciomacadden@gmail.com", password: "password"

    ActiveAuthentication::Mailer.with(token: "test-token", user: user).magic_link
  end

  # Preview this email at http://localhost:3000/rails/mailers/active_authentication/mailer/password_reset_instructions
  def password_reset_instructions
    user = User.create email: "patriciomacadden@gmail.com", password: "password"

    ActiveAuthentication::Mailer.with(token: "test-token", user: user).password_reset_instructions
  end

  # Preview this email at http://localhost:3000/rails/mailers/active_authentication/mailer/unlock_instructions
  def unlock_instructions
    user = User.create email: "patriciomacadden@gmail.com", password: "password"

    ActiveAuthentication::Mailer.with(token: "test-token", user: user).unlock_instructions
  end
end
