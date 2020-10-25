defmodule Timmo.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Timmo.Repo,
      TimmoWeb.Telemetry,
      {Phoenix.PubSub, name: Timmo.PubSub},
      TimmoWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Timmo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TimmoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
