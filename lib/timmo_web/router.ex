defmodule TimmoWeb.Router do
  use TimmoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TimmoWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers, %{"permissions-policy" => "interest-cohort=()"}
  end

  pipeline :not_browser do
    plug :accepts, ["xml"]
  end

  scope "/", TimmoWeb do
    pipe_through :not_browser

    get "/feed", SiteController, :feed
  end

  scope "/", TimmoWeb do
    pipe_through :browser

    live "/", BlogLive, :root
    live "/about", PageLive, :about
    live "/now", PageLive, :now
    live "/blog", BlogLive, :index
    live "/blog/:id", PostLive, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", TimmoWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TimmoWeb.Telemetry
    end
  end
end
