# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :timmo,
  ecto_repos: [Timmo.Repo]

# Configures the endpoint
config :timmo, TimmoWeb.Endpoint,
  url: [host: "localhost", port: 4000],
  server: true,
  secret_key_base: "7xB4ha98N4270Azb0cZxX3BFtqG/0yBpY4jy7WwXvQ3DLbA8TCT1o+9sGV4XcHYU",
  render_errors: [view: TimmoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Timmo.PubSub,
  live_view: [signing_salt: "7/3EqpdM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
