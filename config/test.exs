use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :redde_api, ReddeApi.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :redde_api, ReddeApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_PASSWORD") || "postgres",
  password: System.get_env("POSTGRES_USER") || "postgres",
  database: System.get_env("POSTGRES_NAME") || "redde_api_test",
  hostname: System.get_env("POSTGRES_PORT_5432_TCP_ADDR") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1