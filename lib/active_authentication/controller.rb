module ActiveAuthentication
  module Controller
    extend ActiveSupport::Concern
    include ActiveSupport::Callbacks

    included do
      helper_method :current_user
      helper_method :user_signed_in?
    end

    def authenticate_user!
      redirect_to new_session_path, alert: t("active_authentication.failure.unauthenticated") unless user_signed_in?
    end

    def current_user
      Current.user ||= user_from_session
    end

    def require_no_authentication
      redirect_to root_path, alert: t("active_authentication.failure.already_signed_in") if user_signed_in?
    end

    def sign_in(user)
      reset_session
      Current.user = user
      session[:user_id] = user.id
    end

    def sign_out
      reset_session
      Current.user = nil
    end

    def user_signed_in?
      current_user.present?
    end

    private

    def scope
      User
    end

    def user_from_session
      User.find_by id: session[:user_id]
    end
  end
end
