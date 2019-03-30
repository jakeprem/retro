defmodule RetroWeb.Presence do
  use Phoenix.Presence,
    otp_app: :retro,
    pubsub_server: Retro.PubSub
end
