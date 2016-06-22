defmodule ReddeApi.MeetingControllerTest do
  use ReddeApi.ConnCase

  alias ReddeApi.{Repo, Meeting}

  @valid_attrs %{day: "2010-04-17", time: "14:00:00", contact_id: 1, address: "Rua dos Bobos, 0"}
  @invalid_attrs %{day: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, meeting_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    meeting = Repo.insert! %Meeting{}
    conn = get conn, meeting_path(conn, :show, meeting)
    assert json_response(conn, 200)["data"] == %{"id" => meeting.id,
      "day" => meeting.day,
      "time" => meeting.time,
      "duration" => meeting.duration,
      "address" => meeting.address,
      "contact_id" => meeting.contact_id,
      "canceled" => meeting.canceled}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, meeting_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, meeting_path(conn, :create), meeting: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Meeting, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, meeting_path(conn, :create), meeting: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    meeting = Repo.insert! %Meeting{}
    conn = put conn, meeting_path(conn, :update, meeting), meeting: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Meeting, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    meeting = Repo.insert! %Meeting{}
    conn = put conn, meeting_path(conn, :update, meeting), meeting: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    meeting = Repo.insert! %Meeting{}
    conn = delete conn, meeting_path(conn, :delete, meeting)
    assert response(conn, 204)
    refute Repo.get(Meeting, meeting.id)
  end
end
