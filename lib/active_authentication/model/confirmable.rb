module ActiveAuthentication
  module Model
    module Confirmable
      extend ActiveSupport::Concern

      included do
        generates_token_for :email_confirmation, expires_in: ActiveAuthentication.email_confirmation_token_expires_in

        normalizes :unconfirmed_email, with: -> { _1.strip.downcase }

        validates :unconfirmed_email, format: {with: URI::MailTo::EMAIL_REGEXP}, allow_blank: true

        after_initialize do
          @set_unconfirmed_email = true
          @send_email_confirmation_instructions = true
        end

        before_update :set_unconfirmed_email, if: :set_unconfirmed_email?
        after_save :send_email_confirmation_instructions, if: :send_email_confirmation_instructions?
      end

      def confirm
        @send_email_confirmation_instructions = false
        @set_unconfirmed_email = false

        update email: unconfirmed_email, unconfirmed_email: nil
      end

      def send_email_confirmation_instructions
        token = generate_token_for :email_confirmation
        ActiveAuthentication::Mailer.with(token: token, user: self).email_confirmation_instructions.deliver
      end

      def send_email_confirmation_instructions?
        @send_email_confirmation_instructions && unconfirmed_email.present?
      end

      def unconfirmed?
        unconfirmed_email.present?
      end

      private

      def set_unconfirmed_email
        self.unconfirmed_email = email
        self.email = email_was
      end

      def set_unconfirmed_email?
        @set_unconfirmed_email && email_changed?
      end
    end
  end
end
