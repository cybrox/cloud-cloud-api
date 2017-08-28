defmodule Cloud.Source do
  use Supervisor

  @moduledoc """
  Supervisor for handling information source
  This will handle the current state of our cloud-cloud, as well
  as fetching weather information from a remote service
  """

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end


  def init([]) do
    children = [
      worker(Cloud.Source.Fetcher, []),
      worker(Cloud.Source.Keeper, []),
      worker(Cloud.Source.State, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end