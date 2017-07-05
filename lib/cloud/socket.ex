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
      worker(Cloud.Socket.Dispatcher, []),
      worker(Cloud.Socket.Acceptor, [])
    ]

    supervise(children, strategy: :one_for_all)
  end

end
