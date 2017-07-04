defmodule Cloud.Dispatcher do
  use GenServer

  require Logger

  @moduledoc """
  Dispatcher for socket communication with the cloud-cloud.
  This will wait for the device to log in and then periodically
  (or on user interaciton) send it respective state updates.
  """

  def start_link do
    GenServer.start_link(__MODULE__, %{server: nil, client: nil}, name: __MODULE__)
  end


  def init(state) do
    Logger.info "Starting websocket dispatcher"
    Process.send(self(), :await_connect, [:nosuspend])

    {:ok, state}
  end

  def handle_info(:await_connect, _state) do
    wsport = Application.get_env(:cloud, :device_port)
    Logger.info "Awaiting connection on wss:#{wsport}"

    server = Socket.Web.listen!(wsport)
    client = Socket.Web.accept!(server)
    client |> Socket.Web.accept!()

    Process.send(self(), :await_auth, [:nosuspend])
    {:noreply, %{server: server, client: client}}
  end

  def handle_info(:await_auth, state) do
    auth_secret = Application.get_env(:cloud, :auth_secret)
    case Socket.Web.recv!(state.client) do
      {:text, ^auth_secret} -> Socket.Web.send!(state.client, {:text, "ok"})
      _ ->
        IO.inspect state.server
        Socket.Web.close(state.client, :normal)
        Process.send(self(), :await_connect, [:nosuspend])
    end

    {:noreply, state}
  end
end