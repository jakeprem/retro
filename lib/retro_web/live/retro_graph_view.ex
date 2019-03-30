defmodule RetroWeb.RetroGraphView do
  use Phoenix.LiveView

  alias RetroWeb.Presence

  def render(assigns) do
    RetroWeb.PageView.render("retro_graph.html", assigns)
  end

  def mount(%{server_id: server_id, session_id: id} = _session, socket) do
    RetroWeb.Endpoint.subscribe("retro:" <> id)

    Presence.track(self(), "retro:id", server_id, %{meta: "data"})
    Presence.track(self(), "retros", id, %{server_id: server_id})

    {:ok, assign(socket, values: %{}, id: id)}
  end

  def handle_info(%{payload: %{business_value: bv, happiness: hap, client_id: cid}}, socket) do
    vals =
      socket.assigns
      |> Map.get(:values, %{})
      |> Map.put(cid, {convert_bv(bv), convert_hap(hap)})

    {:noreply, assign(socket, values: vals)}
  end

  def handle_info(msg, socket) do
    IO.inspect(msg, label: "MESSAGE")

    {:noreply, socket}
  end

  defp convert_bv(bv) do
    String.to_integer(bv) * 684 / 10
  end

  defp convert_hap(hap) do
    200 - String.to_integer(hap) * 200 / 10
  end
end
