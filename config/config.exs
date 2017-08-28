# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logger, 
  backends: [:console],
  compile_time_purge_level: :debug

config :cloud, basic_auth: [
  username: "cloud-cloud",
  password: "yourpassword",
  realm: "cloud-cloud"
]

import_config "cloud.exs"
