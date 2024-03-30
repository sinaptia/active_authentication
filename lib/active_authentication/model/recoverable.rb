module ActiveAuthentication
  module Model
    module Recoverable
      extend ActiveSupport::Concern

      included do
        generates_token_for :password_reset, expires_in: ActiveAuthentication.password_reset_token_expires_in
      end

      def send_password_reset_instructions
        token = generate_token_for :password_reset
        ActiveAuthentication::Mailer.with(token: token, user: self).password_reset_instructions.deliver
      end
    end
  end
end
