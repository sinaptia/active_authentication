require "pauth/controller"
require "pauth/model"

module Pauth
  class Engine < ::Rails::Engine
    initializer :pauth_controller do
      ActiveSupport.on_load :action_controller_base do
        include Pauth::Controller
      end

      ActiveSupport.on_load :active_record do
        include Pauth::Model
      end
    end
  end
end
