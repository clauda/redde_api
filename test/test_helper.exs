ExUnit.start

Mix.Task.run "ecto.create", ~w(-r ReddeApi.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r ReddeApi.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(ReddeApi.Repo)

