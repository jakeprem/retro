defmodule RetroWeb.RetroFormView do
  use Phoenix.LiveView

  def render(assigns) do
    RetroWeb.PageView.render("retro_form.html", assigns)
  end

  def mount(%{client_id: client_id}, socket) do
    {:ok,
     assign(socket, session_id: nil, client_id: client_id, current_values: %{bv: nil, hap: nil})}
  end

  def handle_event("join_session", %{"session_id" => session_id} = _val, socket) do
    {:noreply, assign(socket, session_id: session_id)}
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
      |> IO.inspect(label: "SENT VALUES")
    )

    {:noreply, assign(socket, current_values: %{bv: business_value, hap: happiness})}
  end
end
