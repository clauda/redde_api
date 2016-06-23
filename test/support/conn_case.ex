defmodule ReddeApi.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  imports other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias ReddeApi.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]

      import ReddeApi.Router.Helpers

      # The default endpoint for testing
      @endpoint ReddeApi.Endpoint

      @session Plug.Session.init(
        store: :cookie,
        key: "_app",
        encryption_salt: "edder",
        signing_salt: "edder"
      )

      def login(conn, resource, claims) do
        conn
        |> Plug.Session.call(@session)
        |> Plug.Conn.fetch_session()
        |> Guardian.Plug.sign_in(resource, :token, claims)
        |> assign(:current_user, resource)
        |> put_session(:user_id, resource.id)
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ReddeApi.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ReddeApi.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.conn()}
  end
end
