module ActiveAuthentication
  module Model
    module Authenticatable
      extend ActiveSupport::Concern

      included do
        has_secure_password

        normalizes :email, with: -> { _1.strip.downcase }

        validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, uniqueness: true
        validates :password, length: {minimum: ActiveAuthentication.min_password_length}, allow_blank: true
      end
    end
  end
end
