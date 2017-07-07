defmodule Cloud.Socket.Heartbeat do
  use GenServer

  require Logger

  @moduledoc """
  Heartbeat module, will keep an eye on our client
  """

  @heartbeat_interval 10_000


  def start_link do
    GenServer.start_link(__MODULE__, %{active: false, alive: false}, name: __MODULE__)
  end

  def start_heartbeat do
    GenServer.cast(__MODULE__, :start_heartbeat)
  end

  def stop_heartbeat do
    GenServer.cast(__MODULE__, :stop_heartbeat)
  end

  def keep_alive do
    GenServer.cast(__MODULE__, :keep_alive)
  end


  def init(state) do
    {:ok, state}
  end

  def handle_info(:heartbeat, %{active: true}=state) do
    case state.alive do
      true ->
        Process.send_after(self(), :heartbeat, @heartbeat_interval)
      false ->
        Logger.debug "Closing socket connection, no heartbeat!"
        raise "Lost connection to client"
    end
    {:noreply, %{state | alive: false}}
  end

  def handle_info(:heartbeat, %{active: false}=state) do
    {:noreply, %{state | alive: false}}
  end

  def handle_cast(:start_heartbeat, state) do
    Logger.debug "Starting heartbeat for active connection"
    Process.send(self(), :heartbeat, [:nosuspend])
    {:noreply, %{state | active: true, alive: true}}
  end

  def handle_cast(:stop_heartbeat, state) do
    Logger.debug "Stopping heartbeat for active connection"
    {:noreply, %{state | active: false}}
  end

  def handle_cast(:keep_alive, state) do
    {:noreply, %{state | alive: true}}
  end
end
