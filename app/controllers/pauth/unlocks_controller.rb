class Pauth::UnlocksController < ApplicationController
  before_action :require_no_authentication
  before_action :set_user, only: :show

  def new
  end

  def create
    @user = User.find_by email: params[:email]
    @user&.send_unlock_instructions if @user&.locked?

    redirect_to root_path, notice: t(".success")
  end

  def show
    @user.unlock
    sign_in @user

    redirect_to root_url, notice: t(".success")
  end

  private

  def set_user
    @user = User.find_by_token_for :unlock, params[:token]

    redirect_to root_url, alert: t(".invalid_token") unless @user.present?
  end
end
