defmodule Cloud.Web.Router do
  use Plug.Router

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
    send_resp(conn, 200, "ok")
  end

  # Catchall endpoint
  match _ do
    send_resp(conn, 400, "404 Not Found")  
  end
end
