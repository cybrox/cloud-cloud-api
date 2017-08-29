defmodule Cloud.Source.Keeper do
  use GenServer

  @moduledoc """
  Keeper of the current online weather state.
  This caches the weather state fetched from openweathermap in order to instantly
  provide it when the user switches from any other mode to weather mode.
  """

  def start_link() do
    clear_sky = %{weather: 3, intensity: 9}
    GenServer.start_link(__MODULE__, clear_sky, name: __MODULE__)
  end

  def set_weather(weather) do
    GenServer.cast(__MODULE__, {:set_weather, weather})
  end

  def get_weather do
    GenServer.call(__MODULE__, :get_weather)
  end


  def init(state) do
    {:ok, state}
  end


  def handle_call(:get_weather, _from, weather) do
    {:reply, weather, weather}
  end

  def handle_cast({:set_weather, weather}, _state) do
    {:noreply, weather}
  end
end
