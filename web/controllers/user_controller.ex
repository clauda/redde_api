defmodule ReddeApi.UserController do
  use ReddeApi.Web, :controller

  alias ReddeApi.User

  plug :scrub_params, "user" when action in [:create, :registration]

  def create(conn, %{"user" => user_params}) do
    query = 
      (from user in User,
        where: user.uuid == ^user_params["uuid"]
        and user.platform == ^user_params["platform"], limit: 1)

    case Repo.one(query) do
      nil -> IO.puts("Not found!")
      user -> conn |> render("show.json", user: user)
    end

    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ReddeApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def registration(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.registration_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ReddeApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def profile(conn, %{}) do
    current_user = Guardian.Plug.current_resource(conn)
    render(conn, "show.json", user: current_user)
  end

end