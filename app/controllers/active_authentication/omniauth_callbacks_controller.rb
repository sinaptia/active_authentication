class ActiveAuthentication::OmniauthCallbacksController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    provider = auth["provider"]

    @authentication = Authentication.find_or_create_by uid: auth["uid"], provider: provider

    @authentication.update auth_data: auth.as_json

    if user_signed_in?
      if @authentication.user == current_user
        redirect_to root_path, notice: t(".already_linked", provider: provider)
      else
        @authentication.update user: current_user
        redirect_to root_path, notice: t(".successfully_linked", provider: provider)
      end
    elsif @authentication.user.blank?
      @user = User.find_or_initialize_by email: auth.dig("info", "email")
      @user.password = SecureRandom.hex if @user.new_record?

      @authentication.update user: @user

      sign_in @authentication.user
      redirect_to root_path, notice: t(".successfully_signed_up", provider: provider)
    else
      sign_in @authentication.user
      redirect_to root_path, notice: t("active_authentication.sessions.create.success")
    end
  end
end
