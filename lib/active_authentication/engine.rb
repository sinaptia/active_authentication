require "active_authentication/controller"
require "active_authentication/model"

module ActiveAuthentication
  class Engine < ::Rails::Engine
    initializer :active_authentication_controller do
      ActiveSupport.on_load :action_controller_base do
        include ActiveAuthentication::Controller
      end

      ActiveSupport.on_load :active_record do
        include ActiveAuthentication::Model
      end
    end
  end
end
