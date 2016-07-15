defmodule ReddeApi.UserTest do
  use ReddeApi.ModelCase

  alias ReddeApi.User

  @device_attrs %{platform: "Android", uuid: "<3phoenix", version: "kitkat"}
  @valid_attrs %{email: "bar@foo.com", password: "<3phoenix"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @device_attrs)
    assert changeset.valid?
  end

  test "changeset, email too short " do
    changeset = User.registration_changeset(
      %User{}, Map.put(@valid_attrs, :email, "")
    )
    refute changeset.valid?
  end

  test "changeset, email invalid format" do
    changeset = User.registration_changeset(
      %User{}, Map.put(@valid_attrs, :email, "foo.com")
    )
    refute changeset.valid?
  end

  test "invalid password: too short" do
    changeset = User.registration_changeset(%User{}, @valid_attrs)
    assert changeset.changes.password_hash
    assert changeset.valid?
  end

  test "invalid on update password too short" do
    changeset = User.registration_changeset(
      %User{}, Map.put(@valid_attrs, :password, "12345")
    )
    refute changeset.valid?
  end
end