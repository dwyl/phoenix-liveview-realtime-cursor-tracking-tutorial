defmodule LiveCursorsWeb.Router do
  use LiveCursorsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LiveCursorsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", LiveCursorsWeb do
    pipe_through :browser
    pipe_through :protect_from_forgery

    live "/", Cursors
  end
end
