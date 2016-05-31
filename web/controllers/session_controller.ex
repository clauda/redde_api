defmodule ReddeApi.SessionController do
  use ReddeApi.Web, :controller

  alias ReddeApi.Auth

  def new(conn, _) do 
    render conn, "new.html"
  end

  def create(conn, %{"session" => user_params}) do
    case Auth.authenticate(conn, user_params["email"], user_params["password"], repo: Repo) do
      {:ok, conn} ->
        new_conn = Guardian.Plug.api_sign_in(conn, conn.assigns[:current_user])
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        exp = Map.get(claims, "exp")

        new_conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", "#{exp}")
        |> render("login.json", jwt: jwt)
      {:error, reason, conn} ->
        conn
        |> put_status(500)
        |> render("error.json", message: reason)
    end
  end

  def logout(conn, _params) do  
    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)
    render "logout.json"
  end 
end