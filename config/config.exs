# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :selenia_server, SeleniaServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "szDL/LVos9hRS3N3KFKP/5KNT9aaSu6YUhm8XcFz/dBXjK4ySFYr36Lb9FSLjxeE",
  render_errors: [view: SeleniaServerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: SeleniaServer.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
