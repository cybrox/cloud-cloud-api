defmodule Cloud.Socket.Heartbeat do
  use GenServer

  require Logger

  @moduledoc """
  Webinterface state synchronizer
  """

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end


  def init(state) do
    {:ok, state}
  end
end
