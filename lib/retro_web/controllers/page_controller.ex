defmodule RetroWeb.PageController do
  use RetroWeb, :controller
  alias Phoenix.LiveView

  @alphabet ?a..?z
            |> Enum.to_list()
            |> List.to_string()
            |> String.upcase()

  def index(conn, _params) do
    render(conn, :index)
  end

  def retro_graph(conn, _params) do
    {server_id, conn} = get_or_put_id_in_session(conn, :server_id) 
    id = Nanoid.generate(4, "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    LiveView.Controller.live_render(conn, RetroWeb.RetroGraphView,
      session: %{
        server_id: server_id,
        id: id
      }
    )
  end

  def retro_form(conn, _params) do
    {id, conn} = get_or_put_id_in_session(conn, :client_id)

    IO.inspect(id, label: "CLIENT ID FROM SESSION")

    LiveView.Controller.live_render(conn, RetroWeb.RetroFormView, session: %{client_id: id})
  end

  def root(conn, params) do
    p =
      params
      |> Map.put("nid", Nanoid.generate(4, @alphabet))

    text(conn, inspect(p))
  end

  defp get_or_put_id_in_session(conn, key) do
    case get_session(conn, key) do
      nil ->
        id = generate_id()
        {id, put_session(conn, key, id)}

      id ->
        {id, conn}
    end
  end

  defp generate_id do
    Nanoid.generate(16)
  end
end
