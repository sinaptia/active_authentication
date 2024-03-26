require "pauth/version"
require "pauth/engine"
require "pauth/routes"

module Pauth
  include ActiveSupport::Configurable

  autoload :Controller, "pauth/controller"
  autoload :Model, "pauth/model"

  module Controller
    autoload :Lockable, "pauth/controller/lockable"
    autoload :Trackable, "pauth/controller/trackable"
  end

  module Model
    autoload :Authenticatable, "pauth/model/authenticatable"
    autoload :Confirmable, "pauth/model/confirmable"
    autoload :Lockable, "pauth/model/lockable"
    autoload :Recoverable, "pauth/model/recoverable"
    autoload :Registerable, "pauth/model/registerable"
    autoload :Trackable, "pauth/model/trackable"
  end

  module Test
    autoload :Helpers, "pauth/test/helpers"
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
