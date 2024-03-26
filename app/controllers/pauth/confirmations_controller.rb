class Pauth::ConfirmationsController < ApplicationController
  before_action :require_no_authentication, except: :show
  before_action :set_user, only: :show

  def new
  end

  def create
    @user = User.find_by unconfirmed_email: params[:email]
    @user&.send_email_confirmation_instructions

    redirect_to root_path, notice: t(".success")
  end

  def show
    @user.confirm
    sign_in(@user) unless user_signed_in?

    redirect_to root_url, notice: t(".success")
  end

  private

  def set_user
    @user = User.find_by_token_for :email_confirmation, params[:token]

    redirect_to root_url, alert: t(".invalid_token") unless @user.present?
  end
end
