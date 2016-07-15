defmodule ReddeApi.UserControllerTest do
  use ReddeApi.ConnCase

  alias ReddeApi.User
  @device_attrs %{platform: "Android", uuid: "<3phoenix", version: "kitkat"}
  @valid_attrs %{email: "foo@bar.com", password: "s3cr3t", name: "Claudia", company: "Phoenix", platform: "Android", uuid: "<3phoenix", version: "kitkat"}
  @invalid_attrs %{email: nil}

  setup do  
    current_user = create_user(%{name: "jane"})
    {:ok, token, full_claims} = Guardian.encode_and_sign(current_user, :api)
    {:ok, %{current_user: current_user, token: token, claims: full_claims}}
  end

  def create_user(%{name: name}) do
    User.changeset(%User{name: name, uuid: "q1w2e3", email: "#{name}@email.com"})
    |> Repo.insert!
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post(conn, user_path(conn, :create), user: @valid_attrs)
    body = json_response(conn, 201)
    assert body["id"]
    assert body["name"]
    assert body["email"]
    assert body["company"]
    assert body["platform"]
    assert body["uuid"]
    assert body["version"]
    refute body["password"]
    assert Repo.get_by(User, email: "foo@bar.com")
  end

  test "no auth required! anyone can use this incredible app", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @device_attrs
    assert json_response(conn, 201)["errors"] != %{}
  end

  test "profile", context do
    conn = conn
      |> login(context.current_user, context.claims)
      |> get(user_path(conn, :profile))
    body = json_response(conn, 200)
    assert body["name"]
    assert body["email"]
    assert body["uuid"]
  end

  test "registration", %{conn: conn} do
    user = create_user(%{name: "john"})
    conn = conn |> put(user_path(conn, :registration, user), user: @valid_attrs)

    body = json_response(conn, 200)
    assert body["name"]
    assert body["email"]
  end

end