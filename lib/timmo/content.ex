defmodule Timmo.Content do
  @moduledoc false
  use NimblePublisher,
    build: Timmo.Content.Page,
    from: "priv/pages/*.md",
    as: :pages

  defmodule NotFoundError do
    defexception [:message]
  end

  def all_pages, do: @pages

  def get_page_by_name(name) do
    Enum.find(
      all_pages(),
      {:error, %NotFoundError{message: "page with name=#{name} not found"}},
      &(&1.name == name)
    )
  end
end
