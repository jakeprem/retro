# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :retro, RetroWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zH5cTBkUCqybf49XJjmlK1I5UOk7Yk1pdUc5UJ35D1ieutDe5M2WXwzElZcYROi2",
  render_errors: [view: RetroWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Retro.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix,
  json_library: Jason,
  template_engines: [
    leex: Phoenix.LiveView.Engine
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
