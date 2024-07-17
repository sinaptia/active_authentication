module ActiveAuthentication
  module Model
    module Magiclinkable
      extend ActiveSupport::Concern

      included do
        generates_token_for :magic_link, expires_in: ActiveAuthentication.magic_link_token_expires_in
      end

      def send_magic_link
        token = generate_token_for :magic_link
        ActiveAuthentication::Mailer.with(token: token, user: self).magic_link.deliver
      end
    end
  end
end
