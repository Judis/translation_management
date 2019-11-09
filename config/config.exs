# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tr,
  ecto_repos: [Tr.Repo]

# Configures the endpoint
config :tr, TrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "M5LKzEf9h4cpdzyHJ30jZVptBPP1+BL8antxbrT37QN8GQ8De6AiDvdbQKm2LFr/",
  render_errors: [view: TrWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Tr.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
