defmodule Cloud.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  @moduledoc """
  Plug Router for our cloud-cloud api
  """

  get "/" do
    version = Cloud.version()
    hostname = Cloud.hostname()
    send_resp(conn, 200, "cloud-cloud:#{version}@#{hostname}")
  end

  get "/weather" do
    send_resp(conn, 200, "hi")
  end
end
