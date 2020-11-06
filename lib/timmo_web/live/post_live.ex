defmodule TimmoWeb.PostLive do
  @moduledoc false
  use TimmoWeb, :live_view

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    post = Timmo.Blog.get_post_by_id(id)

    {:ok,
     socket
     |> assign(:post, post)
     |> assign(:page_title, post.title)
     |> assign_meta(post)}
  end
end
