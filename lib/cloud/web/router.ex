defmodule Cloud.Web.Router do
  use Plug.Router

  require Logger
  alias Cloud.Source.State
  alias Cloud.Source.Keeper
  alias Cloud.Socket.Dispatcher

  plug BasicAuth, use_config: {:cloud, :basic_auth}
  plug Plug.Static, at: "/", from: {:cloud, "priv/static"}
  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
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
  get "/config" do
    current_state = Cloud.Source.State.get_state()
    send_resp(conn, 200, Poison.encode!(current_state))
  end

  # API endpoint for webinterface
  post "/config" do
    {:ok, params, conn} = Plug.Parsers.JSON.parse(conn, "application", "json", %{}, json_decoder: Poison)

    params = for {key, val} <- params, into: %{}, do: {String.to_atom(key), val}

    case params.mode do
      0 -> State.set_state(:off, params)
      1 -> State.set_state(:weather, Keeper.get_weather())
      2 -> State.set_state(:manual, params)
      _ -> Logger.error "Received unknown mode"
    end

    send_resp(conn, 200, "")
  end

  # API endpoint for resetting device
  post "/reset" do
    Dispatcher.send_display_state(%{command: :reset})
    send_resp(conn, 200, "OK")
  end
  
  # API Endpoint for updating device
  post "/update" do
    binfile = conn.params["binfile"]
    if binfile != nil do
      {:ok, info} = File.stat binfile.path
      if Map.get(info, :size, 0) > 3_000_000 do
        conn
        |> send_resp(400, "I don't like this file!")
        |> halt()
      else
        File.cp(binfile.path, to_string(:code.priv_dir(:cloud)) <> "/static/firmware.bin")

        Logger.debug "Sending update request to device!"
        Dispatcher.send_display_state(%{command: :update})
        
        conn
        |> put_resp_header("location", "/")
        |> send_resp(302, "Going back home")
        |> halt()
      end
    end
  end

  # Catchall endpoint
  match _ do
    send_resp(conn, 400, "404 Not Found")  
  end
end
