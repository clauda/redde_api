defmodule ReddeApi.ContactController do
  use ReddeApi.Web, :controller

  alias ReddeApi.Contact

  plug :scrub_params, "contact" when action in [:create, :update]

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    query = from c in Contact, where: c.user_id == ^current_user.id, select: c
    contacts = Repo.all(query)
    render(conn, "index.json", contacts: contacts)
  end

  def create(conn, %{"contact" => contact_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    changeset = Contact.changeset(%Contact{user_id: current_user.id}, contact_params)

    case Repo.insert(changeset) do
      {:ok, contact} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", contact_path(conn, :show, contact))
        |> render("show.json", contact: contact)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ReddeApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    contact = Repo.get!(Contact, id)
    render(conn, "show.json", contact: contact)
  end

  def update(conn, %{"id" => id, "contact" => contact_params}) do
    contact = Repo.get!(Contact, id)
    changeset = Contact.changeset(contact, contact_params)

    case Repo.update(changeset) do
      {:ok, contact} ->
        render(conn, "show.json", contact: contact)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ReddeApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    contact = Repo.get!(Contact, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(contact)

    send_resp(conn, :no_content, "")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: session_path(conn, :new))
  end

end
