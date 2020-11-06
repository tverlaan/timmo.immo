defprotocol TimmoWeb.Metadata do
  @doc """
  Title will be used for title and og:title
  """
  @spec title(Metadata.t()) :: String.t()
  def title(data)

  @doc """
  Description will be used for description and og:description
  """
  @spec description(Metadata.t()) :: String.t()
  def description(data)

  @doc """
  Author will be used for author and og:author
  """
  @spec author(Metadata.t()) :: String.t()
  def author(data)

  @doc """
  Type will be used for og:type
  """
  @spec type(Metadata.t()) :: String.t()
  def type(data)

  @doc """
  Image will be used for og:image & twitter:image
  """
  @spec image(Metadata.t()) :: String.t()
  def image(data)

  @doc """
  Additional can specify additional data that is unqiue for different categories. For example `article`.
  It must be a list of tuples
  """
  @spec additionals(Metadata.t()) :: List.t()
  def additionals(data)
end

defmodule TimmoWeb.Metadata.Default do
  @moduledoc false
  defstruct []
end

defimpl TimmoWeb.Metadata, for: TimmoWeb.Metadata.Default do
  def title(_), do: Timmo.title()
  def description(_), do: Timmo.description()
  def author(_), do: Timmo.name()
  def type(_), do: "website"
  def additionals(_), do: []

  def image(_) do
    %{
      path: Path.join("images", "share.png"),
      alt: Timmo.title(),
      type: "image/png",
      w: "600",
      h: "600"
    }
  end
end

defimpl TimmoWeb.Metadata, for: Timmo.Blog.Post do
  alias TimmoWeb.Metadata

  def title(post), do: post.title
  def description(post), do: post.description
  def author(post), do: post.author
  def type(_), do: "article"

  def additionals(post) do
    [
      {"article:published_time", Timmo.datetime(post.date)},
      {"article:author", post.author},
      {"article:section", "Software Development"}
    ] ++
      for tag <- post.tags do
        {"article:tag", tag}
      end
  end

  def image(_), do: Metadata.image(%Metadata.Default{})
end

defimpl TimmoWeb.Metadata, for: Timmo.Content.Page do
  alias TimmoWeb.Metadata

  def title(page), do: "#{page.title} · #{Timmo.name()}"
  def description(page), do: page.summary
  def author(_), do: Timmo.name()
  def type(_), do: "website"
  def additionals(_), do: []

  def image(_), do: Metadata.image(%Metadata.Default{})
end
