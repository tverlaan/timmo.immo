defmodule Timmo.Repo do
  use Ecto.Repo,
    otp_app: :timmo,
    adapter: Ecto.Adapters.Postgres
end
