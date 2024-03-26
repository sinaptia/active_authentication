module Pauth
  module Controller
    module Lockable
      extend ActiveSupport::Concern

      included do
        set_callback :failed_sign_in, :before, :increment_failed_attempts
        set_callback :failed_sign_in, :after, :set_alert

        private

        def increment_failed_attempts
          user = User.find_by email: params[:email]
          user&.increment_failed_attempts
        end

        def set_alert
          user = User.find_by email: params[:email]

          if user.locked?
            flash[:alert] = t "pauth.failure.locked", count: user.failed_attempts
          end
        end
      end
    end
  end
end
