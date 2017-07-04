# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :cloud,
  client_port: 6660,
  device_port: 6661,
  auth_secret: "cloud-my-butt",
  api_key: "d3eca8838531a07f8d5efd88f4a07d45"

config :logger, 
  backends: [:console],
  compile_time_purge_level: :debug
