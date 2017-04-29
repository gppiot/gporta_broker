defmodule GportaBroker.Web.GppRemoteChannel do
  use GportaBroker.Web, :channel

  def join("broker:gpp_remote", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in(event, payload, socket) do
    device_id = payload["gpp_device_id"]
    case Registry.lookup(GportaBroker.DeviceInstanceRegistry, device_id) do
      [] -> {:reply, {:error, payload}, socket}
      [{pid,_}] ->
        send(pid, {:msg, event, self()})
        {:reply, :ok, socket}
    end
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (gpp_device:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_info({:msg, event, payload}, socket) do
    push(socket, event, payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
