class Pauth::PasswordsController < ApplicationController
  before_action :require_no_authentication
  before_action :set_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:email]
    @user&.send_password_reset_instructions
    redirect_to root_url, notice: t(".success")
  end

  def edit
  end

  def update
    if @user.update(user_params)
      sign_in @user
      redirect_to root_url, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by_token_for :password_reset, params[:token]

    redirect_to root_url, alert: t(".invalid_token") unless @user.present?
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
