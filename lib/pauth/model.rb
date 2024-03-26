module Pauth
  module Model
    extend ActiveSupport::Concern

    CONCERNS = %i[authenticatable confirmable lockable recoverable registerable trackable]

    class_methods do
      def authenticates
        Pauth.concerns.each do |concern|
          include const_get(concern.to_s.classify)
        end
      end

      CONCERNS.each do |concern|
        define_method(:"#{concern}?") { Pauth.concerns.include? concern }
      end
    end
  end
end
