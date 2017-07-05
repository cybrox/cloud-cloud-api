defmodule Cloud.Socket.Dispatcher do
  use GenServer

  require Logger
  alias Cloud.Socket.Acceptor
  alias Cloud.Model.DisplayManual
  alias Cloud.Model.DisplayWeather

  @moduledoc """
  Dispatcher for socket communication with the cloud-cloud.
  This will wait for the device to log in and then periodically
  (or on user interaciton) send it respective state updates.
  """

  @default_state %{server: nil, client: nil, open: false}

  def start_link do
    GenServer.start_link(__MODULE__, @default_state, name: __MODULE__)
  end

  def send_display(display) do
    :ok = GenServer.call(__MODULE__, {:send_display, display})
  end

  def close_connection do
    GenServer.cast(__MODULE__, :close_connection)
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

    Logger.debug "New connection from #{client.headers["origin"]}"
    Process.send(self(), :await_auth, [:nosuspend])
    {:noreply, %{state | client: client}}
  end

  def handle_info(:await_auth, state) do
    auth_secret = Application.get_env(:cloud, :auth_secret)
    case Socket.Web.recv!(state.client) do
      {:text, ^auth_secret} ->
        Logger.debug "Successfully established connection"
        Socket.Web.send!(state.client, {:text, "ok"})
        Acceptor.set_client(state.client)
        {:noreply, %{state | open: true}}

      _ ->
        Logger.debug "Failed to establish connection"
        Socket.Web.close(state.client, :handshake)
        Process.send(self(), :await_connect, [:nosuspend])
        {:noreply, %{state | open: false}}
    end
  end

  def handle_call({:send_display, display}, _from, state) do
    with true <- state.open do
      display_info = serialize_display_information(display)
      Socket.Web.send!(state.client, {:text, display_info})
      {:reply, :ok, state}
    else
      _ -> {:reply, :notopen, state}
    end
  end

  def handle_cast(:close_connection, state) do
    Logger.debug "Closing current client connection"
    Socket.Web.close(state.client)
    Process.send(self(), :await_connect, [:nosuspend])
    {:noreply, %{state | client: nil}}
  end


  defp serialize_display_information(%DisplayWeather{}=info) do
    "[cc:1:#{info.weather}:#{info.intensity}]"
  end

  defp serialize_display_information(%DisplayManual{}=info) do
    "[cc:1:#{info.color}:#{info.pulse}]"
  end
end
