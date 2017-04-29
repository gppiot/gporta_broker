defmodule GportaBroker.Application do
  @moduledoc """
  The GportaBroker Application Service.

  The gporta_broker system business domain lives in this application.

  Exposes API to clients such as the `GportaBroker.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      
    ], strategy: :one_for_one, name: GportaBroker.Supervisor)
  end
end
