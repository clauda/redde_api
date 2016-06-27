defmodule ReddeApi.MeetingControllerTest do
  use ReddeApi.ConnCase

  alias ReddeApi.{Repo, User, Contact, Meeting}

  @valid_attrs %{day: "2010-04-17", time: "14:00:00", address: "Rua dos Bobos, 0"}
  @invalid_attrs %{day: nil}

  setup do
    current_user = create_user(%{name: "jane"})
    contact = Contact.changeset(%Contact{fullname: "Claudia", user_id: current_user.id, code_area: 11, phone_number: "99999999"}) |> Repo.insert!

    {:ok, token, full_claims} = Guardian.encode_and_sign(current_user, :api)
    {:ok, %{current_user: current_user, token: token, claims: full_claims, contact: contact}}
  end

  def create_user(%{name: name}) do
    User.registration_changeset(%User{}, %{email: "#{name}@reddeapp.com.br", password: "<3phoenix"}) 
    |> Repo.insert!
  end

  def create_meeting(options) do
    Meeting.changeset(%Meeting{day: Ecto.Date.utc, time: Ecto.Time.utc, address: "Baker St"}, options)
    |> Repo.insert! |> Repo.preload([:user, :contact])
  end

  test "unauthorize" do
    conn = conn |> get(meeting_path(conn, :index))
    assert response(conn, 302)
  end

  test "lists all entries by user on index", %{claims: claims, current_user: current_user, contact: contact} do
    meeting = create_meeting(%{contact_id: contact.id, user_id: current_user.id})
    conn = conn |> login(current_user, claims) |> get(meeting_path(conn, :index))
    refute json_response(conn, 200)["data"] == []
    assert Enum.at(json_response(conn, 200)["data"], 0)["contact"]["id"] == contact.id
  end

  test "lists all entries by date", %{claims: claims, current_user: current_user, contact: contact} do
    create_meeting(%{contact_id: contact.id, day: "2016-06-27", user_id: current_user.id})
    conn = conn |> login(current_user, claims) |> get(meeting_path(conn, :index, date: "2016-06-27"))
    assert json_response(conn, 200)["data"] != []
    assert Enum.at(json_response(conn, 200)["data"], 0)["day"] == "2016-06-27"
  end

  test "shows chosen resource", %{claims: claims, current_user: current_user, contact: contact} do
    meeting = create_meeting(%{contact_id: contact.id})
    conn = conn 
      |> login(current_user, claims) 
      |> get(meeting_path(conn, :show, meeting))
    
    assert json_response(conn, 200)["data"] == %{"id" => meeting.id,
      "day" => Ecto.Date.to_iso8601(meeting.day),
      "time" => Ecto.Time.to_iso8601(meeting.time),
      "duration" => meeting.duration,
      "address" => meeting.address,
      "contact" => %{
        "id" => meeting.contact.id,
        "fullname" => meeting.contact.fullname,
        "code_area" => meeting.contact.code_area,
        "phone_number" => meeting.contact.phone_number
      },
      "canceled" => meeting.canceled}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{claims: claims, current_user: current_user} do
    assert_error_sent 404, fn ->
      conn |> login(current_user, claims) |> get(meeting_path(conn, :show, -1))
    end
  end

  test "creates and renders resource when data is valid", %{claims: claims, current_user: current_user, contact: contact} do
    params = Map.merge(@valid_attrs, %{contact_id: contact.id})
    conn = conn |> login(current_user, claims) |> post(meeting_path(conn, :create), meeting: params)
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Meeting, params)
  end

  test "does not create resource and renders errors when data is invalid", %{claims: claims, current_user: current_user} do
    conn = conn |> login(current_user, claims) |> post(meeting_path(conn, :create), meeting: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{claims: claims, current_user: current_user, contact: contact} do
    meeting = create_meeting(%{contact_id: contact.id})
    conn = conn |> login(current_user, claims) |> put(meeting_path(conn, :update, meeting), meeting: @valid_attrs)

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Meeting, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{claims: claims, current_user: current_user, contact: contact} do
    meeting = create_meeting(%{contact_id: contact.id})
    conn = conn |> login(current_user, claims) |> put(meeting_path(conn, :update, meeting), meeting: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{claims: claims, current_user: current_user, contact: contact} do
    meeting = create_meeting(%{contact_id: contact.id})
    conn = conn |> login(current_user, claims) |> delete(meeting_path(conn, :delete, meeting))
    
    assert json_response(conn, 200)["data"]["id"]
    assert json_response(conn, 200)["data"]["canceled"]
    assert Repo.get(Meeting, meeting.id)
  end
end
