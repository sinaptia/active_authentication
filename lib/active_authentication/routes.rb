module ActionDispatch::Routing
  class Mapper
    def active_authentication
      scope module: :active_authentication do
        ActiveAuthentication.concerns.each { |concern|
          send(concern) if respond_to?(concern, true)
        }
      end
    end

    private

    def authenticatable
      resource :session, only: [:new, :create, :destroy]
    end

    def confirmable
      resources :confirmations, param: :token, only: [:new, :create, :show]
    end

    def lockable
      resources :unlocks, param: :token, only: [:new, :create, :show]
    end

    def registerable
      resources :registrations, only: [:new, :create]
      resource :profile, only: [:edit, :update, :destroy], path: :profile, controller: :registrations
    end

    def recoverable
      resources :passwords, param: :token, only: [:new, :create, :edit, :update]
    end
  end
end
