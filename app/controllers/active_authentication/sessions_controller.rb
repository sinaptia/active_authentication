class ActiveAuthentication::SessionsController < ApplicationController
  include ActiveSupport::Callbacks

  before_action :require_no_authentication, except: :destroy
  before_action :authenticate_user!, only: :destroy

  define_callbacks :successful_sign_in, :failed_sign_in, :sign_out

  def new
  end

  def create
    @user = scope.authenticate_by email: params[:email], password: params[:password]

    if @user.present?
      run_callbacks :successful_sign_in do
        sign_in @user
      end

      redirect_to root_path, notice: t(".success")
    else
      run_callbacks :failed_sign_in do
        flash[:alert] = t(".invalid_email_or_password")
      end

      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    run_callbacks :sign_out do
      sign_out
    end
    redirect_to root_url, notice: t(".success")
  end
end
