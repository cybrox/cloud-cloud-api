defmodule Cloud.Source.Fetcher do
  use GenServer

  @moduledoc """
  Feches weather from an external source and provides it when requested
  """

  alias Cloud.Source.State

  @city_id "7287513"
  @minute 60 * 1000
  @interval 10 * @minute
  @initdelay 10_000


  def start_link do
    GenServer.start_link(__MODULE__, %{code: 0}, name: __MODULE__)
  end

  def get_weather do
    GenServer.call(__MODULE__, :get_weather)
  end


  def init(state) do
    Process.send_after(self(), :fetch_weather, @initdelay)
    {:ok, state}
  end

  def handle_info(:fetch_weather, state) do
    fetch_weather()
    run_self_after_delay()
    {:noreply, state}
  end

  def handle_call(:get_weather, _from, state) do
    {:reply, state, state}
  end


  defp run_self_after_delay do
    Process.send_after(self(), :fetch_weather, @interval)
  end

  defp fetch_weather do
    if State.get_mode == :weather do
      IO.puts "weather!"
      #https://gist.githubusercontent.com/cybrox/09169ffa3691c5ab27e193b4d0cbc79a/raw/50fe1154d7c6010e016e0906902e1a4023f90bad/test.json
    end
  end
end
