module Pauth
  module Controller
    extend ActiveSupport::Concern
    include ActiveSupport::Callbacks

    included do
      helper_method :current_user
      helper_method :user_signed_in?
    end

    def authenticate_user!
      redirect_to new_session_path, alert: t("pauth.failure.unauthenticated") unless user_signed_in?
    end

    def current_user
      @current_user ||= session[:user_id] && User.find(session[:user_id])
    end

    def require_no_authentication
      redirect_to root_path, alert: t("pauth.failure.already_signed_in") if user_signed_in?
    end

    def sign_in(user)
      session[:user_id] = user.id
    end

    def sign_out
      reset_session
      session[:user_id] = nil
    end

    def user_signed_in?
      current_user.present?
    end
  end
end
