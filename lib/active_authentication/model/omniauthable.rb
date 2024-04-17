module ActiveAuthentication
  module Model
    module Omniauthable
      extend ActiveSupport::Concern

      included do
        has_many :authentications, dependent: :destroy
      end
    end
  end
end
