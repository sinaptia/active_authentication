require "active_authentication/version"
require "active_authentication/engine"
require "active_authentication/routes"

module ActiveAuthentication
  include ActiveSupport::Configurable

  autoload :Controller, "active_authentication/controller"
  autoload :Current, "active_authentication/current"
  autoload :Model, "active_authentication/model"

  module Controller
    autoload :Authenticatable, "active_authentication/controller/authenticatable"
    autoload :Lockable, "active_authentication/controller/lockable"
    autoload :Timeoutable, "active_authentication/controller/timeoutable"
    autoload :Trackable, "active_authentication/controller/trackable"
  end

  module Model
    autoload :Authenticatable, "active_authentication/model/authenticatable"
    autoload :Confirmable, "active_authentication/model/confirmable"
    autoload :Lockable, "active_authentication/model/lockable"
    autoload :Omniauthable, "active_authentication/model/omniauthable"
    autoload :Recoverable, "active_authentication/model/recoverable"
    autoload :Registerable, "active_authentication/model/registerable"
    autoload :Timeoutable, "active_authentication/model/timeoutable"
    autoload :Trackable, "active_authentication/model/trackable"
  end

  module Test
    autoload :Helpers, "active_authentication/test/helpers"
  end

  # authenticatable
  config_accessor :min_password_length, default: 6

  # confirmable
  config_accessor :email_confirmation_token_expires_in, default: 24.hours

  # lockable
  config_accessor :unlock_token_expires_in, default: 24.hours
  config_accessor :max_failed_attempts, default: 10

  # omniauthable
  config_accessor :omniauth_providers, default: []

  # recoverable
  config_accessor :password_reset_token_expires_in, default: 1.hour

  # timeoutable
  config_accessor :timeout_in, default: 30.minutes
end
