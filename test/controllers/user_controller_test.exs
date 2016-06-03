defmodule ReddeApi.UserControllerTest do
  use ReddeApi.ConnCase

  alias ReddeApi.User
  @valid_attrs %{email: "foo@bar.com", password: "s3cr3t", name: "Claudia", company: "Phoenix"}
  @invalid_attrs %{}

  setup do  
    current_user = create_user(%{name: "jane"})
    {:ok, token, full_claims} = Guardian.encode_and_sign(current_user, :api)
    {:ok, %{current_user: current_user, token: token, claims: full_claims}}
  end

  def create_user(%{name: name}) do
    User.registration_changeset(%User{}, %{name: name, email: "#{name}@example.com", password: "<3phoenix"}) 
    |> Repo.insert!
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    body = json_response(conn, 201)
    assert body["email"]
    assert body["name"]
    assert body["company"]
    refute body["id"]
    refute body["password"]
    assert Repo.get_by(User, email: "foo@bar.com")
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "profile", context do
    conn = conn
      |> login(context.current_user, context.claims)
      |> get(user_path(conn, :profile))
    body = json_response(conn, 200)
    assert body["name"]
    assert body["email"]
  end

end