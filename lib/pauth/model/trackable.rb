module Pauth
  module Model
    module Trackable
      extend ActiveSupport::Concern

      included do
        Pauth::SessionsController.send :include, Pauth::Controller::Trackable
      end

      def track(request)
        self.sign_in_count += 1

        self.last_sign_in_at = current_sign_in_at
        self.current_sign_in_at = Time.now

        self.last_sign_in_ip = current_sign_in_ip
        self.current_sign_in_ip = request.remote_ip

        save
      end
    end
  end
end
