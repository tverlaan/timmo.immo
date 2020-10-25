defmodule Timmo.Content.Page do
  @moduledoc """
  Definition of a page for Timmo's website.
  """
  @enforce_keys [:name, :title, :body]
  defstruct [:name, :title, :body]

  def build(filename, attrs, body) do
    name = Path.basename(filename, ".md")
    struct!(__MODULE__, [name: name, body: body] ++ Map.to_list(attrs))
  end
end
