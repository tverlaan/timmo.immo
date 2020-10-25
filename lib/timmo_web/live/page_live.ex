defmodule TimmoWeb.PageLive do
  @moduledoc false
  use TimmoWeb, :live_view

  @impl true
  def mount(_params, _session, %{assigns: %{live_action: :index}} = socket) do
    {:ok, push_redirect(socket, to: Routes.blog_path(socket, :index))}
  end

  def mount(_params, _session, %{assigns: %{live_action: action}} = socket) do
    page = Atom.to_string(action)
    page = Timmo.Content.get_page_by_name(page)

    {:ok,
     socket
     |> assign(:page, page)
     |> assign(:page_title, page.title)}
  end
end
