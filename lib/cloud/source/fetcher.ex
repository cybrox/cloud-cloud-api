defmodule Cloud.Source.Fetcher do
  use GenServer

  @moduledoc """
  Feches weather from an external source and provides it when requested
  """

  require Logger
  alias Cloud.Source.State
  alias Cloud.Weather

  @minute 60 * 1000
  @interval 10 * @minute
  @initdelay 10_000

  @city_id "7287513"
  @api_url "https://gist.githubusercontent.com/cybrox/09169ffa3691c5ab27e193b4d0cbc79a/raw/50fe1154d7c6010e016e0906902e1a4023f90bad/test.json"



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
      Logger.debug "Fetching weather data from online service"
      case HTTPoison.get(@api_url) do
        {:ok, response} ->
          case Poison.decode(response.body) do
            {:ok, payload} ->
              [weather] = payload["weather"]
              system  = payload["sys"]
              clouds  = payload["clouds"]
              parse_weather_data(weather["id"], system["sunrise"], system["sunset"], clouds["all"])
            {:error, _} ->
              Logger.error "Failed to decode weather data"
          end
        {:error, _} ->
          Logger.error "Failed to fetch weather data"
      end
    end
  end

  defp parse_weather_data(weather_code, sunrise, sunset, cloudiness) do
    %{weather: weather, intensity: intensity} = Weather.get_weather_for_code(weather_code)

    # Respect cloudiness in cloudy skies
    intensity = case weather do
      4 -> Float.ceil((cloudiness / 100) * 10)  
      _ -> intensity
    end

    # Override weather, if we're in sunset/sunrise time
    

    State.set_state(:weather, %{weather: weather, intensity: intensity})
  end
end
