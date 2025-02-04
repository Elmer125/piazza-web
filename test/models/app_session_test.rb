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
require "test_helper"

class AppSessionTest < ActiveSupport::TestCase
  setup do
    @user = users(:jerry)
  end
  
  test "token is generated and saved when a new record is created" do
    app_session = @user.app_sessions.create

    assert app_session.persisted?
    assert_not_nil app_session.token_digest
    assert app_session.authenticate_token(app_session.token)
  end
end
