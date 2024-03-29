defmodule ReddeApi.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [ checkpw: 2, dummy_checkpw: 0 ]

  alias ReddeApi.{Repo, User}

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn) do
    user_id = get_session(conn, :user_id)
    user = user_id && Repo.get(User, user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def fail(conn) do
    conn |> assign(:current_user, "failed")
  end

  def device_auth(conn, user) do
    cond do
      user ->
        {:ok, login(conn, user)}
          user -> {:error, :unauthorized, conn}
            {:error, :not_found, conn}
    end
  end

  def email_auth(conn, email, given_pass) do
    user = Repo.get_by(User, email: email)
    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
          user -> {:error, :unauthorized, conn}
          true -> dummy_checkpw()
            {:error, :not_found, conn}
    end
  end

end
