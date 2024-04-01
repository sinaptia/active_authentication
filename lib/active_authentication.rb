require "active_authentication/version"
require "active_authentication/engine"
require "active_authentication/routes"

module ActiveAuthentication
  include ActiveSupport::Configurable

  autoload :Controller, "active_authentication/controller"
  autoload :Current, "active_authentication/current"
  autoload :Model, "active_authentication/model"

  module Controller
    autoload :Lockable, "active_authentication/controller/lockable"
    autoload :Trackable, "active_authentication/controller/trackable"
  end

  module Model
    autoload :Authenticatable, "active_authentication/model/authenticatable"
    autoload :Confirmable, "active_authentication/model/confirmable"
    autoload :Lockable, "active_authentication/model/lockable"
    autoload :Recoverable, "active_authentication/model/recoverable"
    autoload :Registerable, "active_authentication/model/registerable"
    autoload :Trackable, "active_authentication/model/trackable"
  end

  module Test
    autoload :Helpers, "active_authentication/test/helpers"
  end

  config_accessor :concerns, default: %i[authenticatable confirmable lockable recoverable registerable trackable]

  # authenticatable
  config_accessor :min_password_length, default: 6

  # confirmable
  config_accessor :email_confirmation_token_expires_in, default: 24.hours

  # lockable
  config_accessor :unlock_token_expires_in, default: 24.hours
  config_accessor :max_failed_attempts, default: 10

  # recoverable
  config_accessor :password_reset_token_expires_in, default: 1.hour

  # registerable

  # trackable
end
