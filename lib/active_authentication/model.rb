module ActiveAuthentication
  module Model
    extend ActiveSupport::Concern

    CONCERNS = %i[authenticatable confirmable lockable omniauthable recoverable registerable timeoutable trackable]

    class_methods do
      def authenticates_with(*concerns)
        include Authenticatable
        concerns.each do |concern|
          include const_get(concern.to_s.classify)
        end
      end
      alias_method :authenticates, :authenticates_with

      CONCERNS.each do |concern|
        define_method(:"#{concern}?") { User.included_modules.include? const_get(concern.to_s.classify) }
      end
    end
  end
end
