module ActiveAuthentication
  module Test
    module Helpers
      def sign_in(user, password: "password")
        post session_path, params: {email: user.email, password: password}
      end

      def sign_out
        delete session_path
      end
    end
  end
end
