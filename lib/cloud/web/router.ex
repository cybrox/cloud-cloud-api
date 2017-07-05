defmodule Cloud.Web.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    version = Cloud.version()
    hostname = Cloud.hostname()
    send_resp(conn, 200, "cloud-cloud:#{version}@#{hostname}")
  end

  match _ do
    send_resp(conn, 400, "404 Not Found")  
  end
end
