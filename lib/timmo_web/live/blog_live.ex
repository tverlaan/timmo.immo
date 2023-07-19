defmodule TimmoWeb.BlogLive do
  @moduledoc false
  use TimmoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    posts = Timmo.Blog.all_posts()

    {:ok,
     socket
     |> assign(:posts, posts)
     |> assign(:page_title, "Blog")
     |> assign(:canonical_url, TimmoWeb.Endpoint.url() <> "/blog")
     |> assign_meta()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%= for post <- @posts do %>
      <article role="article" class="space-y-3 pb-4 border-b">
        <header>
          <h1 class="text-brand text-2xl md:text-4xl font-bold">
            <%= live_redirect post.title, to: Routes.post_path(@socket, :show, post.id), class: "hover:text-golden-600 dark:hover:text-golden-400" %>
          </h1>
        </header>
        <div class="flex justify-between">
          <p class="text-sm"><%= post.date %></p>
          <%# <p class="text-gray-800 text-sm"><%= Enum.join(post.tags, ", ")</p> %>
        </div>
        <section class="prose md:prose-lg dark:prose-dark">
          <p><%= post.description %></p>
        </section>
      </article>
    <% end %>
    """
  end
end
