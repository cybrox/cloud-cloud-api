defmodule Cloud.PingPong do
  use GenServer

  require Logger

  @moduledoc """
  Simple ping/pong implemenation. A process for this module's ping listener
  will be spawned whenever a new websocket is opened. It will receive pings
  from the client and return pongs.
  """

  @default_state %{client: nil}

  def start_link do
    GenServer.start_link(__MODULE__, @default_state, name: __MODULE__)
  end

  def init(state) do
    Process.send(self(), :await_ping, [:nosuspend])
    {:ok, state}
  end

  def set_client(client) do
    GenServer.cast(__MODULE__, {:set_client, client})
  end


  def handle_info(:await_ping, state) do
    if state.client != nil do
      case Socket.Web.recv!(state.client) do
        {:ping, cookie} -> Socket.Web.pong!(state.client, cookie)
        {:close, reason} -> Cloud.Dispatcher.close_connection()
      end
      Process.send(self(), :await_ping, [:nosuspend])
    end
    {:noreply, state}
  end

  def handle_cast({:set_client, client}, state) do
    Logger.debug "New client set for pingpong handler"
    Process.send(self(), :await_ping, [:nosuspend])
    {:noreply, %{state | client: client}}
  end
end
