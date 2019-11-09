use Mix.Config

# Configure your database
config :tr, Tr.Repo,
  username: "postgres",
  password: "postgres",
  database: "tr_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tr, TrWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
