defmodule TimmoWeb.LayoutView do
  use TimmoWeb, :view
  @compile_env Mix.env()

  def brand_color(), do: "#bc8d02"

  def compiled_for_prod?() do
    @compile_env == :prod
  end
end
