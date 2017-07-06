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

  def handle_cast({:set_weather, %{weather: weather, intensity: intensity}}, state) do
    if weather == nil && intensity == nil do
      {:noreply, %{state | mode: :weather}}
    else
      {:noreply, %{state | mode: :weather, weather: %DisplayWeather{weather: weather, intensity: intensity}}}
    end
  end

  def handle_cast({:set_manual, %{color: color, pulse: pulse}}, state) do
    if color == nil && pulse == nil do
      {:noreply, %{state | mode: :manual}}
    else
      {:noreply, %{state | mode: :manual, manual: %DisplayManual{color: color, pulse: pulse}}}
    end
  end
end
