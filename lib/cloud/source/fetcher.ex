defmodule Cloud.Source.Fetcher do
  use GenServer

  @moduledoc """
  Feches weather from an external source and provides it when requested
  """

  require Logger
  alias Cloud.Source.State
  alias Cloud.Weather

  @fetch_interval 10 * (60 * 1000)
  @initial_delay 10_000

  @sun_transition_duration 40 * 60#s

  @city_id "7287513"
  @api_url "https://gist.githubusercontent.com/cybrox/09169ffa3691c5ab27e193b4d0cbc79a/raw/50fe1154d7c6010e016e0906902e1a4023f90bad/test.json"



  def start_link do
    GenServer.start_link(__MODULE__, %{code: 0}, name: __MODULE__)
  end

  def get_weather do
    GenServer.call(__MODULE__, :get_weather)
  end


  def init(state) do
    Process.send_after(self(), :fetch_weather, @initial_delay)
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
    Process.send_after(self(), :fetch_weather, @fetch_interval)
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

  def parse_weather_data(weather_code, sunrise, sunset, cloudiness) do
    %{weather: weather, intensity: intensity} = Weather.get_weather_for_code(weather_code)

    # Respect cloudiness in cloudy skies
    intensity = case weather do
      4 -> Float.ceil((cloudiness / 100) * 10)  
      _ -> intensity
    end

    # Override weather, if we're in sunset/sunrise time
    current_time = :os.system_time(:seconds)
    sunrise_start = sunrise - @sun_transition_duration;
    sunset_end = sunset + @sun_transition_duration;

    weather_info = cond do
      current_time > sunrise_start && current_time < sunrise ->
        abs_end = sunrise - sunrise_start;
        abs_cur = current_time - sunrise_start;
        %{weather: 1, intensity: (abs_cur / abs_end) * 10}
      current_time > sunset && current_time < sunset_end ->
        abs_end = sunset_end - sunset;
        abs_cur = current_time - sunset;
        %{weather: 2, intensity: (abs_cur / abs_end) * 10}
      true ->
        %{weather: weather, intensity: intensity}
    end

    State.set_state(:weather, weather_info)
  end
end
