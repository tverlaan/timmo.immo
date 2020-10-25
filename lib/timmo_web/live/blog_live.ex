defmodule TimmoWeb.BlogLive do
  @moduledoc false
  use TimmoWeb, :live_view

  def mount(_params, _session, socket) do
    posts = Timmo.Blog.all_posts()

    {:ok,
     socket
     |> assign(:posts, posts)
     |> assign(:page_title, "Blog")}
  end
end
