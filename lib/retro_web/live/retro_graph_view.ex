defmodule RetroWeb.RetroGraphView do
  use Phoenix.LiveView

  def render(assigns) do
    RetroWeb.PageView.render("retro_graph.html", assigns)
  end

  def mount(_session, socket) do
    id = Nanoid.generate(4, "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    RetroWeb.Endpoint.subscribe("retro:" <> id)

    {:ok, assign(socket, values: %{}, id: id)}
  end

  # def handle_event("github_deploy", _value, socket) do
  #   IO.inspect(socket, label: "HANDLE_EVENT")
  #   Process.send_after(self(), :create_org, 1000)
  #   {:noreply, assign(socket, deploy_step: "Starting deploy...")}
  # end

  def handle_info(%{payload: %{business_value: bv, happiness: hap, client_id: cid}}, socket) do
    IO.inspect({bv, hap, cid}, label: "VALUES")

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
    String.to_integer(bv)*684/10
  end

  defp convert_hap(hap) do
    200-String.to_integer(hap)*200/10
  end

  # def handle_info(:create_repo, socket) do
  #   Process.send_after(self(), :push_contents, 1000)
  #   {:noreply, assign(socket, deploy_step: "Creating Repo...")}
  # end
end
