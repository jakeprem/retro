defmodule RetroWeb.PageController do
  use RetroWeb, :controller
  alias Phoenix.LiveView

  @alphabet ?a..?z
            |> Enum.to_list()
            |> List.to_string()
            |> String.upcase()

  def index(conn, _params) do
    id = Nanoid.generate(4, @alphabet)
    render(conn, :index, %{id: id})
  end

  def retro_graph(conn, _params) do
    id = Nanoid.generate(4, "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    LiveView.Controller.live_render(conn, RetroWeb.RetroGraphView,
      session: %{
        id: id
      }
    )
  end

  def retro_form(conn, _params) do
    {id, conn} = get_and_put_client_id(conn)

    IO.inspect(id, label: "CLIENT ID FROM SESSION")

    LiveView.Controller.live_render(conn, RetroWeb.RetroFormView, session: %{client_id: id})
  end

  def root(conn, params) do
    p =
      params
      |> Map.put("nid", Nanoid.generate(4, @alphabet))

    text(conn, inspect(p))
  end

  defp get_and_put_client_id(conn) do
    case get_session(conn, :client_id) do
      nil ->
        id = generate_client_id()
        {id, put_session(conn, :client_id, id)}

      id ->
        {id, conn}
    end
  end

  defp generate_client_id do
    Nanoid.generate(16)
  end
end
