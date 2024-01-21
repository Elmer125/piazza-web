class Organization < ApplicationRecord

  #Relationships --------------------------------------------------------------
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
end
