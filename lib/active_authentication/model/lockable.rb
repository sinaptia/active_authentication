module ActiveAuthentication
  module Model
    module Lockable
      extend ActiveSupport::Concern

      included do
        ActiveAuthentication::SessionsController.send :include, ActiveAuthentication::Controller::Lockable

        generates_token_for :unlock, expires_in: ActiveAuthentication.unlock_token_expires_in

        scope :unlocked, -> { where locked_at: nil }
      end

      def increment_failed_attempts
        increment :failed_attempts

        lock if failed_attempts == ActiveAuthentication.max_failed_attempts

        save
      end

      def locked?
        locked_at.present?
      end

      def lock
        update locked_at: Time.now

        send_unlock_instructions
      end

      def send_unlock_instructions
        token = generate_token_for :unlock
        ActiveAuthentication::Mailer.with(token: token, user: self).unlock_instructions.deliver
      end

      def unlock
        update failed_attempts: 0, locked_at: nil
      end
    end
  end
end
