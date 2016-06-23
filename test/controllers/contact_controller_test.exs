defmodule ReddeApi.ContactControllerTest do
  use ReddeApi.ConnCase
  use ExUnit.Case, async: true

  alias ReddeApi.{Repo, User, Contact, Region}

  @valid_attrs %{accepted: true, ambitious: 42, code_area: 42, email: "some@content.com", fullname: "Fulano", observations: "Lorem", phone_number: "99999", popularity: 42, purchasing: 42}
  @invalid_attrs %{fullname: "", code_area: nil, phone_number: nil}

  setup do
    Region.changeset(%Region{}, %{code_area: 42, state: "Galaxy"}) 
    |> Repo.insert!

    current_user = create_user(%{name: "jane"})
    {:ok, token, full_claims} = Guardian.encode_and_sign(current_user, :api)
    {:ok, %{current_user: current_user, token: token, claims: full_claims}}
  end

  def create_user(%{name: name}) do
    User.registration_changeset(%User{}, %{email: "#{name}@example.com", password: "<3phoenix"}) 
    |> Repo.insert!
  end

  def create_contact(%{fullname: _fullname, user_id: _user_id} = options) do
    Contact.changeset(%Contact{code_area: 11, phone_number: "99999999"}, options) 
    |> Repo.insert! 
  end

  test "lists all entries", context do
    conn = conn
      |> login(context.current_user, context.claims)
      |> get(contact_path(conn, :index))
    assert json_response(conn, 200)["data"] == []
  end

  test "unauthorize" do
    conn = conn |> get(contact_path(conn, :index))
    assert response(conn, 302)
  end

  test "lists all entries by user", context do
    johndoe = create_user(%{name: "johndoe"})
    create_contact(%{fullname: "valim", user_id: context.current_user.id})
    create_contact(%{fullname: "chris", user_id: johndoe.id})
    
    conn = conn
      |> login(context.current_user, context.claims)
      |> get(contact_path(conn, :index))

    assert Enum.count(json_response(conn, 200)["data"]) == 1
    assert %{"fullname" => "valim"} = hd(json_response(conn, 200)["data"])
  end

  test "shows chosen resource", %{claims: claims, current_user: current_user} do
    contact = create_contact(%{fullname: "Jose Valim", user_id: current_user.id})
    conn = conn
      |> login(current_user, claims)
      |> get(contact_path(conn, :show, contact))
    
    assert json_response(conn, 200)["data"] == %{"id" => contact.id,
      "user_id" => contact.user_id,
      "fullname" => contact.fullname,
      "email" => contact.email,
      "code_area" => contact.code_area,
      "phone_number" => contact.phone_number,
      "ambitious" => contact.ambitious,
      "popularity" => contact.popularity,
      "purchasing" => contact.purchasing,
      "accepted" => contact.accepted,
      "observations" => contact.observations,
      "deleted" => contact.deleted,
      "inserted_at" => Ecto.DateTime.to_iso8601(contact.inserted_at) }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{claims: claims, current_user: current_user} do
    assert_error_sent 404, fn ->
      conn |> login(current_user, claims) |> get(contact_path(conn, :show, -1))
    end
  end

  test "creates and renders resource when data is valid", %{claims: claims, current_user: current_user} do
    conn = conn |> login(current_user, claims) |> post(contact_path(conn, :create), contact: @valid_attrs)
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Contact, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{claims: claims, current_user: current_user} do
    conn = conn |> login(current_user, claims) |> post(contact_path(conn, :create), contact: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{claims: claims, current_user: current_user} do
    contact = create_contact(%{fullname: "Claudia Farias", user_id: current_user.id})
    conn = conn |> login(current_user, claims) |> put(contact_path(conn, :update, contact), contact: @valid_attrs)
    # IO.inspect(conn.resp_body)
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Contact, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{claims: claims, current_user: current_user} do
    contact = create_contact(%{fullname: "Claudia Farias", user_id: current_user.id})
    conn = conn |> login(current_user, claims) |> put(contact_path(conn, :update, contact), contact: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource shouldn't destroy but flag it as deleted", %{claims: claims, current_user: current_user} do
    contact = create_contact(%{fullname: "Claudia Farias", user_id: current_user.id})
    conn = conn |> login(current_user, claims) |> delete(contact_path(conn, :delete, contact))

    assert json_response(conn, 200)["data"]["id"]
    assert json_response(conn, 200)["data"]["deleted"]
    assert Repo.get(Contact, contact.id)
  end
end
