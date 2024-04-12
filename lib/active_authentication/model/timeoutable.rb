module ActiveAuthentication
  module Model
    module Timeoutable
      extend ActiveSupport::Concern

      included do
        ApplicationController.send :include, ActiveAuthentication::Controller::Timeoutable
      end

      def timedout?(last_request_at)
        last_request_at && last_request_at <= ActiveAuthentication.timeout_in.ago
      end
    end
  end
end
