defmodule Cloud.Socket.Acceptor do
  use GenServer

  require Logger
  alias Cloud.Socket.Dispatcher

  @moduledoc """
  The acceptor module will receive a client connection from the dispatcher once
  a connection has been established. From then on, it will accept messages from
  that connection and handle them apropriately.
  """


  @default_state %{client: nil}

  def start_link do
    GenServer.start_link(__MODULE__, @default_state, name: __MODULE__)
  end

  def set_client(client) do
    GenServer.cast(__MODULE__, {:set_client, client})
  end


  def init(state) do
    Process.send(self(), :await_message, [:nosuspend])
    {:ok, state}
  end

  def handle_info(:await_message, state) do
    if state.client != nil do
      new_state = case Socket.Web.recv!(state.client) do
        {:ping, cookie} ->
          Cloud.Socket.Heartbeat.keep_alive()
          Socket.Web.pong!(state.client, cookie)
          state

        {:text, "ping"} ->
          Cloud.Socket.Heartbeat.keep_alive()
          Socket.Web.send(state.client, {:text, "pong"})
          state

        :close ->
          Dispatcher.close_connection()
          %{state | client: nil}

        _ ->
          Logger.debug "Received unexpected message"
          state
      end
      Process.send(self(), :await_message, [:nosuspend])
      {:noreply, new_state}
    else
      {:noreply, state}
    end
  end

  def handle_cast({:set_client, client}, state) do
    Logger.debug "New client set for acceptor handler"
    Process.send(self(), :await_message, [:nosuspend])
    {:noreply, %{state | client: client}}
  end
end
