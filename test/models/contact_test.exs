defmodule ReddeApi.ContactTest do
  use ReddeApi.ModelCase

  alias ReddeApi.Contact

  @valid_attrs %{accepted: true, ambitious: 42, code_area: 42, email: "some content", fullname: "some content", observations: "some content", phone_number: "some content", popularity: 42, purchasing: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Contact.changeset(%Contact{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Contact.changeset(%Contact{}, @invalid_attrs)
    refute changeset.valid?
  end
end
