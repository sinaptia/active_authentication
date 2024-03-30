module ActiveAuthentication
  class Mailer < ApplicationMailer
    def email_confirmation_instructions
      @token, @user = params[:token], params[:user]

      mail to: @user.unconfirmed_email
    end

    def password_reset_instructions
      @token, @user = params[:token], params[:user]

      mail to: @user.email
    end

    def unlock_instructions
      @token, @user = params[:token], params[:user]

      mail to: @user.email
    end
  end
end
