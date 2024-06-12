class ActiveAuthentication::RegistrationsController < ActiveAuthenticationController
  before_action :require_no_authentication, only: [:new, :create]
  before_action :authenticate_user!, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new registration_params

    if @user.save
      sign_in @user
      redirect_to root_path, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if current_user.update(profile_params)
      redirect_to edit_profile_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    sign_out
    redirect_to root_url, notice: t(".success")
  end

  private

  def profile_params
    ActiveAuthentication.profile_params.call self
  end

  def registration_params
    ActiveAuthentication.registration_params.call self
  end
end
