defmodule ReddeApi.ContactTest do
  use ReddeApi.ModelCase

  alias ReddeApi.{Region, User, Contact}

  @valid_attrs %{code_area: 42, fullname: "some one", phone_number: "9999999"}
  @invalid_attrs %{email: nil}

  setup do  
    current_user = create_user(%{name: 'Manu'})
    Region.changeset(%Region{}, %{code_area: 42, state: "Galaxy"}) |> Repo.insert!
    {:ok, %{current_user: current_user}}
  end

  def create_user(%{name: name}) do
    User.registration_changeset(%User{}, %{email: "#{name}@example.com", password: "<3phoenix"}) 
    |> Repo.insert!
  end

  test "changeset with valid attributes", %{current_user: current_user} do
    params = Map.merge(@valid_attrs, %{user_id: current_user.id})
    changeset = Contact.changeset(%Contact{}, params)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Contact.changeset(%Contact{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "contact state should not be nil", %{current_user: current_user} do
    params = Map.merge(@valid_attrs, %{user_id: current_user.id})
    changeset = Contact.changeset(%Contact{}, params)
    assert changeset.changes.state

    contact = Repo.insert!(changeset)
    assert contact.state == "Galaxy"
  end
end
