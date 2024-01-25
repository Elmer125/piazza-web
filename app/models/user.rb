class User < ApplicationRecord
  include User::Authentication
  # Validations ---------------------------------------------------------------
  before_validation :strip_extraneous_spaces


  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }

  #Relationships --------------------------------------------------------------
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  private

  def strip_extraneous_spaces
    self.name = self.name&.strip
    self.email = self.email&.strip
  end
end
