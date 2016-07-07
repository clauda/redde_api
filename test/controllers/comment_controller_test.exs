defmodule ReddeApi.CommentControllerTest do
  use ReddeApi.ConnCase

  alias ReddeApi.{User, Contact, Comment}
  @valid_attrs %{message: "some content", contact_id: 1}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = User.registration_changeset(%User{}, %{email: "name@example.com", password: "<3phoenix"}) |> Repo.insert!
    contact = Contact.changeset(%Contact{fullname: "Shakespeare", code_area: 11, phone_number: "99999999", user_id: user.id}) |> Repo.insert!
    {:ok, conn: put_req_header(conn, "accept", "application/json"), contact: contact}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, comment_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    comment = Repo.insert! %Comment{}
    conn = get conn, comment_path(conn, :show, comment)
    assert json_response(conn, 200)["data"] == %{"id" => comment.id,
      "message" => comment.message,
      "contact_id" => comment.contact_id,
      "kinda" => comment.kinda}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, comment_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, contact: contact} do
    params = Map.merge(@valid_attrs, %{contact_id: contact.id})
    conn = post conn, comment_path(conn, :create), comment: params
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Comment, params)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, comment_path(conn, :create), comment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, contact: contact} do
    params = Map.merge(@valid_attrs, %{contact_id: contact.id})
    comment = Repo.insert! %Comment{}
    conn = put conn, comment_path(conn, :update, comment), comment: params

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Comment, params)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    comment = Repo.insert! %Comment{}
    conn = put conn, comment_path(conn, :update, comment), comment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    comment = Repo.insert! %Comment{}
    conn = delete conn, comment_path(conn, :delete, comment)
    assert response(conn, 204)
    refute Repo.get(Comment, comment.id)
  end
end
