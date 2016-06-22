defmodule ReddeApi.MeetingControllerTest do
  use ReddeApi.ConnCase

  alias ReddeApi.{Repo, User, Meeting}

  @valid_attrs %{day: "2010-04-17", time: "14:00:00", contact_id: 1, address: "Rua dos Bobos, 0"}
  @invalid_attrs %{day: nil}

  setup do
    current_user = create_user(%{name: "jane"})
    {:ok, token, full_claims} = Guardian.encode_and_sign(current_user, :api)
    {:ok, %{current_user: current_user, token: token, claims: full_claims}}
  end

  def create_user(%{name: name}) do
    User.registration_changeset(%User{}, %{email: "#{name}@example.com", password: "<3phoenix"}) 
    |> Repo.insert!
  end

  test "unauthorize" do
    conn = conn |> get(meeting_path(conn, :index))
    assert response(conn, 302)
  end

  test "lists all entries on index", %{claims: claims, current_user: current_user} do
    conn = conn |> login(current_user, claims) |> get(meeting_path(conn, :index))
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{claims: claims, current_user: current_user} do
    meeting = Repo.insert! %Meeting{}
    conn = conn |> login(current_user, claims) |> get(meeting_path(conn, :show, meeting))
    assert json_response(conn, 200)["data"] == %{"id" => meeting.id,
      "day" => meeting.day,
      "time" => meeting.time,
      "duration" => meeting.duration,
      "address" => meeting.address,
      "contact_id" => meeting.contact_id,
      "canceled" => meeting.canceled}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{claims: claims, current_user: current_user} do
    assert_error_sent 404, fn ->
      conn |> login(current_user, claims) |> get(meeting_path(conn, :show, -1))
    end
  end

  test "creates and renders resource when data is valid", %{claims: claims, current_user: current_user} do
    conn = conn |> login(current_user, claims) |> post(meeting_path(conn, :create), meeting: @valid_attrs)
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Meeting, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{claims: claims, current_user: current_user} do
    conn = conn |> login(current_user, claims) |> post(meeting_path(conn, :create), meeting: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{claims: claims, current_user: current_user} do
    meeting = Repo.insert! %Meeting{}
    conn = conn |> login(current_user, claims) |> put(meeting_path(conn, :update, meeting), meeting: @valid_attrs)
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Meeting, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{claims: claims, current_user: current_user} do
    meeting = Repo.insert! %Meeting{}
    conn = conn |> login(current_user, claims) |> put(meeting_path(conn, :update, meeting), meeting: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{claims: claims, current_user: current_user} do
    meeting = Repo.insert! %Meeting{}
    conn = conn |> login(current_user, claims) |> delete(meeting_path(conn, :delete, meeting))
    assert response(conn, 204)
    refute Repo.get(Meeting, meeting.id)
  end
end
