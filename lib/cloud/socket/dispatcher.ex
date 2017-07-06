defmodule Cloud.Socket.Dispatcher do
  use GenServer

  require Logger
  alias Cloud.Source.State
  alias Cloud.Socket.Acceptor

  @moduledoc """
  Dispatcher for socket communication with the cloud-cloud.
  This will wait for the device to log in and then periodically
  (or on user interaciton) send it respective state updates.
  """

  @default_state %{server: nil, client: nil, open: false}

  def start_link do
    GenServer.start_link(__MODULE__, @default_state, name: __MODULE__)
  end

  def send_display_state(state) do
    GenServer.cast(__MODULE__, {:send_display_state, state})
  end

  def close_connection do
    GenServer.cast(__MODULE__, :close_connection)
  end


  def init(state) do
    wsport = Application.get_env(:cloud, :device_port)
    Logger.info "Awaiting connection on ws:#{wsport}"

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
        display_info = serialize_display_information(State.get_state())
        Socket.Web.send!(state.client, {:text, "ok"})
        Socket.Web.send!(state.client, {:text, display_info})
        Acceptor.set_client(state.client)
        {:noreply, %{state | open: true}}

      _ ->
        Logger.debug "Failed to establish connection"
        Socket.Web.close(state.client, :handshake)
        Process.send(self(), :await_connect, [:nosuspend])
        {:noreply, %{state | open: false}}
    end
  end

  def handle_cast({:send_display_state, dispay_state}, state) do
    with true <- state.open do
      display_info = serialize_display_information(dispay_state)
      Socket.Web.send!(state.client, {:text, display_info})
      {:noreply, state}
    else
      _ -> {:noreply, state}
    end
  end

  def handle_cast(:close_connection, state) do
    Logger.debug "Closing current client connection"
    Socket.Web.close(state.client)
    Process.send(self(), :await_connect, [:nosuspend])
    {:noreply, %{state | client: nil}}
  end


  defp serialize_display_information(%{mode: :off}) do
    "[cc:0:?:?]"
  end

  defp serialize_display_information(%{mode: :weather}=params) do
    "[cc:1:#{params.weather.weather}:#{params.weather.intensity}]"
  end

  defp serialize_display_information(%{mode: :manual}=params) do
    "[cc:2:#{params.manual.color}:#{params.manual.pulse}]"
  end

  defp serialize_display_information(_) do
    Logger.error "Received invalid display information"
    ""
  end
end
