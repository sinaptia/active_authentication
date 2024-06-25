class ActiveAuthentication::MagicLinksController < ActiveAuthenticationController
  before_action :require_no_authentication
  before_action :set_user, only: :show

  def new
  end

  def create
    @user = User.find_by email: params[:email]
    @user&.send_magic_link

    redirect_to root_path, notice: t(".success")
  end

  def show
    sign_in @user

    redirect_to root_url, notice: t(".success")
  end

  private

  def set_user
    @user = User.find_by_token_for :magic_link, params[:token]

    redirect_to root_url, alert: t(".invalid_token") unless @user.present?
  end
end
