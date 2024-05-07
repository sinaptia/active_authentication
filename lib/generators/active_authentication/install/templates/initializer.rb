ActiveAuthentication.configure do |config|
  # configuration for the authenticatable concern
  # config.min_password_length = 6

  # configuration for the confirmable concern
  # config.email_confirmation_token_expires_in = 24.hours

  # configuration for the lockable concern
  # config.unlock_token_expires_in = 24.hours
  # config.max_failed_attempts = 10

  # configuration for the recoverable concern
  # config.password_reset_token_expires_in = 1.hour

  # configuration for the registerable concern
  # config_accessor :profile_params, default: ->(controller) {
  #   controller.params.require(:user).permit(:email, :password, :password_confirmation)
  # }
  # by default the registration_params take the same lambda as the profile_params. if you redefine the
  # profile_params setting, you will need to uncomment this line as otherwise it will take the default value,
  # previously defined.
  # config_accessor :registration_params, default: profile_params

  # configuration for the timeoutable concern
  # config.timeout_in = 30.minutes
end
