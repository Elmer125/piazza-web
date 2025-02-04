# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires a name" do
    @user = User.new(
      name: "",
      email: "elmer@example.com",
      password: "password"

    )
    assert_not @user.valid?

    @user.name = "Elmer"
    assert @user.valid?
  end

  test "requires a valid email" do
    @user = User.new(
      name: "Elmer",
      email: "",
      password: "password"
    )
    assert_not @user.valid?

    @user.email = "invalid"
    assert_not @user.valid?

    @user.email = "elmer@example.com"
    assert @user.valid?
  end

  test "requires a unique email" do
    @existing_user = User.create(
      name: "John",
      email: "jd@example.com",
      password: "password"
    )
    assert @existing_user.persisted?

    @user = User.new(
      name: "Jon",
      email: "jd@example.com",
      password: "password"
    )
    assert_not @user.valid?
  end

  test "name and email is stripped of spaces before saving" do
    @user = User.create(
      name: "  Elmer  ",
      email: " elmer@example.com "
    )


    assert_equal "Elmer", @user.name
    assert_equal "elmer@example.com", @user.email
  end


  test "password length must be between 8 and ActiveModel's maximum" do
    @user = User.new(
      name: "Elmer",
      email: "elmer@example.com",
      password:""
    )
    assert_not @user.valid?

    @user.password = "password"
    assert @user.valid?

    max_length = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    @user.password = "a" * (max_length + 1)
    assert_not @user.valid?
  end

  test "can create a session with email and correct password" do
    @app_session = User.create_app_session(
      email: "jerry@example.com",
      password: "password"
    )

    assert_not_nil @app_session
    assert_not_nil @app_session.token
  end

  test "cannot create a session with email and incorrect password" do
    @app_session = User.create_app_session(
      email: "jerry@example.com",
      password: "wrong"
    )
    assert_nil @app_session
  end

  test "creating a session with non existing email returns nil" do
    @app_session = User.create_app_session(
      email: "non-existing@example.com",
      password: "password"
    )
    assert_nil @app_session
  end

  test "can authentica with a valid session id and token" do
    @user = users(:jerry)
    @app_session = @user.app_sessions.create

    assert_equal @app_session, @user.authenticate_app_session(@app_session.id, @app_session.token)
  end

  test "trying to authenticate with a token that doesn't exist returns false" do
    @user = users(:jerry)

    assert_not @user.authenticate_app_session(50, "token")
  end
end