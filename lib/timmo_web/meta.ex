defmodule TimmoWeb.Meta do
  @moduledoc """
  A helper module to navigate the mess of `<meta>`-tags. A lot of the heavylifting is done by the
  `Metadata` protocol.
  """
  alias TimmoWeb.Metadata

  defdelegate title(data), to: Metadata
  defdelegate description(data), to: Metadata
  defdelegate author(data), to: Metadata
  defdelegate type(data), to: Metadata
  defdelegate additionals(data), to: Metadata
  defdelegate image(data), to: Metadata

  def image?(data) do
    data
    |> Metadata.image()
    |> is_map()
  end

  def assigned?(assigns) do
    Map.has_key?(assigns, :meta) and not is_nil(Metadata.impl_for(assigns.meta))
  end

  def assign_meta(conn, data \\ %Metadata.Default{}) do
    assign(conn, :meta, data)
  end

  # Why doesn't Phoenix provide me with this convenient helper? Doesn't seem to hard.
  defp assign(%Plug.Conn{} = conn, key, meta) do
    Plug.Conn.assign(conn, key, meta)
  end

  defp assign(%Phoenix.LiveView.Socket{} = conn, key, meta) do
    Phoenix.Component.assign(conn, key, meta)
  end
end
