defmodule GportaBroker.Web.Router do
  use GportaBroker.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GportaBroker.Web do
    pipe_through :api
  end
end
