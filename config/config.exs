use Mix.Config

config :timmo,
  ecto_repos: [Timmo.Repo]

config :timmo, TimmoWeb.Endpoint,
  url: [host: "localhost", port: 4000],
  server: true,
  secret_key_base: "7xB4ha98N4270Azb0cZxX3BFtqG/0yBpY4jy7WwXvQ3DLbA8TCT1o+9sGV4XcHYU",
  render_errors: [view: TimmoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Timmo.PubSub,
  live_view: [signing_salt: "7/3EqpdM"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :tz,
  reject_time_zone_periods_before_year: 2020,
  build_time_zone_periods_with_ongoing_dst_changes_until_year: NaiveDateTime.utc_now().year + 1

import_config "#{Mix.env()}.exs"
