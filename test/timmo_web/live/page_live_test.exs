defmodule TimmoWeb.PageLiveTest do
  use TimmoWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "TIMMO"
    assert render(page_live) =~ "BlogLive"
  end
end
