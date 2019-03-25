defmodule RetroWeb.PageController do
  use RetroWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, RetroWeb.GithubDeployView, session: %{})
  end

  def root(conn, params) do
    text(conn, inspect(params))
  end
end
