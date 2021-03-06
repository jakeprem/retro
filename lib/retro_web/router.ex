defmodule RetroWeb.Router do
  use RetroWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RetroWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/retro", PageController, :retro_graph
    get "/retro_form", PageController, :retro_form

    get "/root/:id", PageController, :root
  end

  # Other scopes may use custom stacks.
  # scope "/api", RetroWeb do
  #   pipe_through :api
  # end
end
