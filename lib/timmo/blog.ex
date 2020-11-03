defmodule Timmo.Blog do
  @moduledoc false
  @posts_path "priv/posts"
  @build_time DateTime.now!("Europe/Amsterdam")
  use NimblePublisher,
    build: Timmo.Blog.Post,
    from: "#{@posts_path}/*.md",
    as: :posts,
    highlighters: [:makeup_elixir]

  defmodule NotFoundError do
    defexception [:message]
  end

  # The @posts variable is first defined by NimblePublisher.
  # Let's further modify it by sorting all posts by descending date.
  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  # Let's also get all tags
  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  # And finally export them
  def all_posts, do: @posts
  def all_tags, do: @tags

  def get_post_by_id(id) do
    Enum.find(
      all_posts(),
      {:error, %NotFoundError{message: "post with id=#{id} not found"}},
      &(&1.id == id)
    )
  end

  def path, do: @posts_path

  def build_time, do: @build_time
end
