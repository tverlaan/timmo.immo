import Config

config :timmo,
  ecto_repos: [Timmo.Repo]

config :timmo, TimmoWeb.Endpoint,
  url: [host: "localhost", port: 7600],
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
  reject_periods_before_year: 2020,
  build_dst_periods_until_year: NaiveDateTime.utc_now().year + 1

config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.1.0",
  default: [
    args:
      ~w(--config=tailwind.config.js --input=css/app.css --output=../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

import_config "#{Mix.env()}.exs"
