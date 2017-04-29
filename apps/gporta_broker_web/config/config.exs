# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :gporta_broker_web,
  namespace: GportaBroker.Web

# Configures the endpoint
config :gporta_broker_web, GportaBroker.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zWKzd9xT9iOHkol+dIEhoVIP7q9LgJPmlw22MrCSFX1F3h+to0exOiprzNT6XUFi",
  render_errors: [view: GportaBroker.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: GportaBroker.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
