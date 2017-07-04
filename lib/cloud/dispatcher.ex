defmodule Cloud.Dispatcher do
  use GenServer

  require Logger

  @moduledoc """
  Dispatcher for socket communication with the cloud-cloud.
  This will wait for the device to log in and then periodically
  (or on user interaciton) send it respective state updates.
  """

  @default_state %{server: nil, client: nil, open: false}

  def start_link do
    GenServer.start_link(__MODULE__, @default_state, name: __MODULE__)
  end


  def init(state) do
    wsport = Application.get_env(:cloud, :device_port)
    Logger.info "Awaiting connection on wss:#{wsport}"

    server = Socket.Web.listen!(wsport)
    Process.send(self(), :await_connect, [:nosuspend])

    {:ok, %{state | server: server}}
  end

  def handle_info(:await_connect, state) do
    client = Socket.Web.accept!(state.server)
    client |> Socket.Web.accept!()

    Process.send(self(), :await_auth, [:nosuspend])
    {:noreply, %{state | client: client}}
  end

  def handle_info(:await_auth, state) do
    auth_secret = Application.get_env(:cloud, :auth_secret)
    case Socket.Web.recv!(state.client) do
      {:text, ^auth_secret} ->
        Socket.Web.send!(state.client, {:text, "ok"})
        {:noreply, %{state | open: true}}

      _ ->
        Socket.Web.close(state.client, :handshake)
        Process.send(self(), :await_connect, [:nosuspend])
        {:noreply, %{state | open: false}}
    end
  end

  def handle_call({:send_display, display}, _from, state) do
    with true <- state.open do
      {:reply, :ok, state}
    else
      {:reply, :notopen, state}
    end
  end
end