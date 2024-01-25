require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires name" do
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
      name:"Elmer",
      email:"",
      password:"password"
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
      name: " Elmer ",
      email: " elmer@example.com "
    )

    assert_equal "Elmer", @user.name
    assert_equal "elmer@example.com", @user.email
  end
end
