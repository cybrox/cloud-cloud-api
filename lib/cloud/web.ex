defmodule Cloud.Web do
  use Supervisor

  require Logger

  @moduledoc """
  Supervisor for webinterface related purposes
  """

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end


  def init([]) do
    web_port = Application.get_env(:cloud, :client_port)
    Logger.info "Starting webinterface on http:#{web_port}"

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Cloud.Web.Router, [], [port: web_port])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
