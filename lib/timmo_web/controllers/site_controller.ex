defmodule TimmoWeb.SiteController do
  use TimmoWeb, :controller
  @etag <<?", Timmo.Blog.build_time() |> :erlang.phash2() |> Integer.to_string(16)::binary, ?">>

  plug :etag_cache

  def feed(conn, _) do
    conn
    |> put_resp_content_type("application/atom+xml")
    |> put_resp_content_type("text/xml")
    |> render("feed.xml", posts: Timmo.Blog.all_posts())
  end

  def feed_xslt(conn, _) do
    conn
    |> put_resp_content_type("text/xml")
    |> put_resp_content_type("application/xslt+xml")
    |> render("rss-style.xsl")
  end

  defp etag_cache(conn, _) do
    conn =
      conn
      |> put_resp_header("cache-control", "public, max-age=3600")
      |> put_resp_header("etag", @etag)

    if @etag in Plug.Conn.get_req_header(conn, "if-none-match") do
      conn
      |> send_resp(304, "")
      |> halt()
    else
      conn
    end
  end
end
