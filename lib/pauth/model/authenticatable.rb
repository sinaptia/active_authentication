module Pauth
  module Model
    module Authenticatable
      extend ActiveSupport::Concern

      included do
        has_secure_password

        validates :email, presence: true, uniqueness: true
        validates :password, length: {minimum: Pauth.min_password_length}, allow_blank: true
      end
    end
  end
end
