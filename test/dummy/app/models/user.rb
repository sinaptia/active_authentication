class User < ApplicationRecord
  authenticates_with :confirmable, :lockable, :recoverable, :registerable, :trackable
end
