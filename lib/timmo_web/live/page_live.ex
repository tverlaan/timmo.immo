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
     |> assign(:page, page)
     |> assign(:page_title, page.title)
     |> assign_meta(page)}
  end
end
