defmodule ReddeApi.ContactTest do
  use ReddeApi.ModelCase

  alias ReddeApi.{Region, Contact}

  @valid_attrs %{user_id: 1, code_area: 42, fullname: "some one", phone_number: "9999999"}
  @invalid_attrs %{email: nil}

  setup do  
    Region.changeset(%Region{}, %{code_area: 42, state: "Galaxy"}) 
    |> Repo.insert!
    :ok
  end

  test "changeset with valid attributes" do
    changeset = Contact.changeset(%Contact{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Contact.changeset(%Contact{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "contact state should not be nil" do
    changeset = Contact.changeset(%Contact{}, @valid_attrs)
    assert changeset.changes.state

    contact = Repo.insert!(changeset)
    assert contact.state == "Galaxy"
  end
end
