defmodule ReddeApi.SessionView do
  use ReddeApi.Web, :view
  
  def render("show.json", %{session: session}) do
    %{data: render_one(session, ReddeApi.SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{token: session.token}
  end

  def render("login.json", %{jwt: jwt}) do
    %{"token": jwt}
  end

  def render("error.json", _anything) do
    %{errors: "kiiiu"}
  end
end