defmodule ReddeApi.MeetingController do
  use ReddeApi.Web, :controller
  alias ReddeApi.Meeting

  plug :scrub_params, "meeting" when action in [:create, :update]

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def index(conn, _params) do
    meetings = Repo.all(Meeting) |> Repo.preload(:contact)
    render(conn, "index.json", meetings: meetings)
  end

  def create(conn, %{"meeting" => meeting_params}) do
    changeset = Meeting.changeset(%Meeting{}, meeting_params)
    case Repo.insert(changeset) do
      {:ok, meeting} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", meeting_path(conn, :show, meeting))
        |> render("show.json", meeting: Repo.preload(meeting, :contact))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ReddeApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    meeting = Repo.get!(Meeting, id) |> Repo.preload(:contact)
    render(conn, "show.json", meeting: meeting)
  end

  def update(conn, %{"id" => id, "meeting" => meeting_params}) do
    meeting = Repo.get!(Meeting, id) |> Repo.preload(:contact)
    changeset = Meeting.changeset(meeting, meeting_params)
    case Repo.update(changeset) do
      {:ok, meeting} ->
        render(conn, "show.json", meeting: meeting)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ReddeApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    meeting = Repo.get!(Meeting, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(meeting)

    send_resp(conn, :no_content, "")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: session_path(conn, :new))
  end
end
