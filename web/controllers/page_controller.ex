defmodule ReddeApi.PageController do
  use ReddeApi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
