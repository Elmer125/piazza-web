# == Schema Information
#
# Table name: app_sessions
#
#  id           :bigint           not null, primary key
#  user_id      :bigint           not null
#  token_digest :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class AppSession < ApplicationRecord
  belongs_to :user
  has_secure_password :token, validations: false

  # Callback ###################################################################
  before_create {
    self.token = self.class.generate_unique_secure_token
  }

  def to_h
    {
      user_id: user.id,
      app_session_id: id,
      token: self.token,
    }
  end
end
