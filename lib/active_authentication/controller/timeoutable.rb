module ActiveAuthentication
  module Controller
    module Timeoutable
      extend ActiveSupport::Concern

      included do
        before_action :sign_out_user_if_timedout, if: :user_signed_in?
      end

      private

      def sign_out_user_if_timedout
        last_request_at = session[:last_request_at].yield_self do |timestamp|
          Time.at(timestamp).utc if timestamp.present?
        end

        if current_user.timedout?(last_request_at)
          sign_out
          redirect_to root_path, alert: t("active_authentication.failure.timedout")
        end

        session[:last_request_at] = Time.now.utc.to_i
      end
    end
  end
end
