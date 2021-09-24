defmodule TimmoWeb.LayoutView do
  use TimmoWeb, :view
  alias TimmoWeb.Meta

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  @compile_env Mix.env()

  def brand_color(), do: "#bc8d02"

  def compiled_for_prod?() do
    @compile_env == :prod
  end
end
