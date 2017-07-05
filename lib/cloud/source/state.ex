defmodule Cloud.Source.State do
  use GenServer

  alias Cloud.Model.DisplayWeather
  alias Cloud.Model.DisplayManual

  @moduledoc """
  Keeper of the current cloud-cloud state.
  This is mostly influenced by the fetcher and the webinterface
  """

  def start_link() do
    GenServer.start_link(__MODULE__, %{mode: :weather, weather: %DisplayWeather{}, manual: %DisplayManual{}}, name: __MODULE__)
  end

  def set_state(:weather, _params) do
    GenServer.cast(__MODULE__, {:set_weather, nil}) # don't overwrite weather info!
  end

  def set_state(:manual, params) do
    manual = %DisplayManual{color: params["color"], pulse: params["pulse"]}
    GenServer.cast(__MODULE__, {:set_manual, manual})
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

  def handle_cast({:set_weather, nil}, state) do
    {:noreply, %{state | mode: :weather}}
  end

  def handle_cast({:set_weather, weather}, state) do
    {:noreply, %{state | mode: :weather, weather: weather}}
  end

  def handle_cast({:set_manual, manual}, state) do
    {:noreply, %{state | mode: :manual, manual: manual}}
  end
end
