defmodule Cloud.Web.Router do
  use Plug.Router

  require Logger
  alias Cloud.Source.State

  plug Plug.Static, at: "/", from: {:cloud, "priv/static"}
  plug :match
  plug :dispatch

  # API redirection for serving static file on index
  get "/" do
    conn
    |> put_resp_header("location", "/webinterface.html")
    |> send_resp(302, "")
  end

  # API endpoint for metadata
  get "/info" do
    version = Cloud.version()
    hostname = Cloud.hostname()
    send_resp(conn, 200, "cloud-cloud:#{version}@#{hostname}")
  end

  # API endpoint for webinterface
  post "/config" do
    {:ok, params, conn} = Plug.Parsers.JSON.parse(conn, "application", "json", %{}, json_decoder: Poison)

    case params["mode"] do
      1 -> State.set_state(:weather, params)
      2 -> State.set_state(:manual, params)
      _ -> Logger.error "Received unknown mode"
    end

    send_resp(conn, 200, "")
  end

  # Catchall endpoint
  match _ do
    send_resp(conn, 400, "404 Not Found")  
  end
end
