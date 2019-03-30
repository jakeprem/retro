defmodule RetroWeb.RetroFormView do
  use Phoenix.LiveView

  alias Phoenix.Socket.Broadcast

  alias RetroWeb.Presence

  def render(assigns) do
    RetroWeb.PageView.render("retro_form.html", assigns)
  end

  def mount(%{client_id: client_id}, socket) do
    Phoenix.PubSub.subscribe(Retro.PubSub, "retros")
    current_retros = Presence.list("retros")

    {:ok,
     assign(socket,
       session_id: nil,
       client_id: client_id,
       current_values: %{bv: nil, hap: nil},
       current_retros: current_retros
     )}
  end

  def handle_event("join_session", %{"session_id" => session_id} = _val, socket) do
    {:noreply, assign(socket, session_id: session_id)}
  end

  def handle_event("join_session", click_val, socket) do
    {:noreply, assign(socket, session_id: click_val)}
  end

  def handle_event("send", %{"bv" => business_value, "hap" => happiness}, socket) do
    RetroWeb.Endpoint.broadcast!(
      "retro:" <> socket.assigns.session_id,
      "submit_values",
      %{
        happiness: happiness,
        business_value: business_value,
        client_id: socket.assigns.client_id
      }
    )

    {:noreply, assign(socket, current_values: %{bv: business_value, hap: happiness})}
  end

  def handle_info(%Broadcast{event: "presence_diff", topic: "retros"} = _msg, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_info(msg, socket) do
    IO.inspect(msg, label: "GOT NEW MESSAGE")
    {:noreply, socket}
  end

  defp fetch(socket) do
    assign(socket, current_retros: Presence.list("retros"))
  end
end
