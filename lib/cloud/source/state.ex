defmodule Cloud.Source.State do
  use GenServer

  alias Cloud.Model.DisplayWeather
  alias Cloud.Model.DisplayManual

  @moduledoc """
  Keeper of the current cloud-cloud state.
  This is mostly influenced by the fetcher and the webinterface
  """

  def start_link() do
    GenServer.start_link(__MODULE__, %{mode: :off, weather: %DisplayWeather{}, manual: %DisplayManual{}}, name: __MODULE__)
  end

  def set_state(:off, _params) do
    GenServer.cast(__MODULE__, {:set_off})
  end

  def set_state(:weather, params) do
    GenServer.cast(__MODULE__, {:set_weather, params})
  end

  def set_state(:manual, params) do
    GenServer.cast(__MODULE__, {:set_manual, params})
  end

  def get_mode do
    GenServer.call(__MODULE__, :get_mode)
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end


  def init(state) do
    {:ok, state}
  end

  def handle_call(:get_mode, _from, state) do
    {:reply, state.mode, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:set_off}, state) do
    {:noreply, %{state | mode: :off}}
  end

  def handle_cast({:set_weather, params}, state) do
    state = %{state | mode: :weather}
    cast_weather_with(state, params)
  end

  def handle_cast({:set_manual, params}, state) do
    state = %{state | mode: :manual}
    cast_manual_with(state, params)
  end


  defp cast_weather_with(state, %{weather: nil, intensity: nil}), do: {:noreply, state}
  defp cast_weather_with(state, %{weather: w, intensity: i}), do: {:noreply, %{state | weather: %DisplayWeather{weather: w, intensity: i}}}
  defp cast_weather_with(state, _), do: {:noreply, state}

  defp cast_manual_with(state, %{color: nil, pulse: nil}), do: {:noreply, state}
  defp cast_manual_with(state, %{color: c, pulse: p}), do: {:noreply, %{state | manual: %DisplayManual{color: c, pulse: p}}}
  defp cast_manual_with(state, _), do: {:noreply, state}
end
