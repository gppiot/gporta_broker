defmodule GportaBroker.Web.GppDeviceChannel do
  use GportaBroker.Web, :channel

  def join("broker:gpp_device:" <> device_id, payload, socket) do
    if authorized?(device_id, payload) do
      {:ok, assign(socket, :remote_requests, %{})}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in(event, payload, socket) do
    IO.inspect "receive pong with payload: #{inspect payload}"
    req_id = payload["req_id"]
    remote_pid = socket.assigns.remote_requests[req_id]
    remote_requests = Map.delete(socket.assigns.remote_requests, req_id)
    send(remote_pid, {:msg, event, payload})
    {:reply, :ok, assign(socket, :remote_requests, remote_requests)}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (gpp_device:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_info({:msg, event, remote_pid}, socket) do
    req_id = :erlang.unique_integer
    remote_requests = Map.put(socket.assigns.remote_requests, req_id, remote_pid)
    push(socket, event, %{req_id: req_id})
    {:noreply, assign(socket, :remote_requests, remote_requests)}
  end

  # Add authorization logic here as required.
  defp authorized?(device_id, _payload) do
    case Registry.register(GportaBroker.DeviceInstanceRegistry, device_id, nil) do
      {:ok, _} -> true
      _ -> false
    end
  end
end
