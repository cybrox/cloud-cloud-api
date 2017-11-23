defmodule Cloud.Socket do
  use Supervisor

  @moduledoc """
  Supervisor for websocket connection related processes.
  This is using a one-for-all strategy in order to comlpetely reset
  the websocket implementation when an unhandled error occurs.
  """

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end


  def init([]) do
    children = [
      worker(Cloud.Socket.Heartbeat, []),
      worker(Cloud.Socket.Dispatcher, []),
      worker(Cloud.Socket.Acceptor, []),
      worker(Cloud.Socket.Interfacer, [])
    ]

    supervise(children, strategy: :one_for_all, max_restarts: 20, max_seconds: 1)
  end

end
