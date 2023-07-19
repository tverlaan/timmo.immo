defmodule TimmoWeb.PageLive do
  @moduledoc false
  use TimmoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    page =
      socket.assigns.live_action
      |> Atom.to_string()
      |> Timmo.Content.get_page_by_name()

    {:ok,
     socket
     |> assign(:page_body, page.body)
     |> assign(:page_title, page.title)
     |> assign_meta(page)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <article role="article" class="space-y-6">
      <h1 class="text-brand text-3xl md:text-4xl font-bold"><%= @page_title %></h1>
      <section class="prose prose-lg md:prose-xl print:prose-sm dark:prose-dark">
        <%= raw(@page_body) %>
      </section>
    </article>
    """
  end
end
