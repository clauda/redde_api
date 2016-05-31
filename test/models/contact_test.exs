defmodule ReddeApi.ContactTest do
  use ReddeApi.ModelCase

  alias ReddeApi.Contact

  @valid_attrs %{user_id: 1, code_area: 42, fullname: "some one", phone_number: "9999999"}
  @invalid_attrs %{email: nil}

  test "changeset with valid attributes" do
    changeset = Contact.changeset(%Contact{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Contact.changeset(%Contact{}, @invalid_attrs)
    refute changeset.valid?
  end
end
