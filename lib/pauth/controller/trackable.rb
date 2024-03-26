module Pauth
  module Controller
    module Trackable
      extend ActiveSupport::Concern

      included do
        set_callback :successful_sign_in, :after, :track

        private

        def track
          current_user.track request
        end
      end
    end
  end
end
