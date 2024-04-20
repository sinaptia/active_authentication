module ActiveAuthentication
  module Controller
    extend ActiveSupport::Concern

    included do
      include Authenticatable
    end
  end
end
