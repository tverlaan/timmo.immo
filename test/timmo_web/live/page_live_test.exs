defmodule TimmoWeb.PageLiveTest do
  use TimmoWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, _page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "TIMMO"
  end
end
