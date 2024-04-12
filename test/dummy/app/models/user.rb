class User < ApplicationRecord
  authenticates_with :confirmable, :lockable, :recoverable, :registerable, :timeoutable, :trackable
end
