defmodule Cloud.Socket.Interfacer do
  use GenServer

  require Logger

  @moduledoc """
  Webinterface state synchronizer
  """

  @initial_state %{server: nil, clients: []}
  @initial_delay 50


  def start_link do
    GenServer.start_link(__MODULE__, @initial_state, name: __MODULE__)
  end


  def init(state) do
    syncer_port = Application.get_env(:cloud, :syncer_port)
    Logger.info "Awaiting connections on ws:#{syncer_port}"
    server = Socket.Web.listen!(syncer_port)
    Process.send_after(self(), :await_connections, @initial_delay)
    {:ok, %{state | server: server}}
  end

  def handle_info(:await_connections, state) do
    Process.spawn(__MODULE__, :await_socket_connection, [state.server], [])

    {:noreply, state}
  end

  def handle_info({:add_client, client}, state) do
    Logger.debug "Adding new client to syncer client list"
    Process.spawn(__MODULE__, :await_message_on_connection, [client], [])
    {:noreply, %{state | clients: [client | state.clients]}}
  end

  def handle_info({:receive_message, from, message}, state) do
    Logger.debug "Received message on syncer socket"
    fanout_clients = state.clients -- [from]
    Enum.each(fanout_clients, fn(client) ->
      Socket.Web.send(client, message)
    end)
    {:noreply, state}
  end


  def await_socket_connection(server) do
    Logger.debug "Awaiting new connection on syncer"
    client = Socket.Web.accept!(server)
    Socket.Web.accept!(client)
    Process.send(__MODULE__, {:add_client, client}, [])
    await_socket_connection(server)
  end

  def await_message_on_connection(client) do
    case Socket.Web.recv(client) do
      {:ok, packet} ->
        Process.send(__MODULE__, {:receive_message, client, packet}, [])
      {:error, _} ->
        nil
    end

    await_message_on_connection(client)
  end
end
