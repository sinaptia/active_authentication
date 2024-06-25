class User < ApplicationRecord
  has_many :authentications

  authenticates_with :confirmable, :lockable, :magiclinkable, :omniauthable, :recoverable, :registerable, :timeoutable, :trackable
end
