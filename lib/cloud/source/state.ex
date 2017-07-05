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

  def set_state(:weather, params) do
    weather = %DisplayWeather{weather: params["weather"], intensity: params["intensity"]}
    GenServer.cast(__MODULE__, {:set_state, %{mode: :weather, weather: weather, manual: nil}})
  end

  def set_state(:manual, params) do
    manual = %DisplayManual{color: params["color"], pulse: params["pulse"]}
    GenServer.cast(__MODULE__, {:set_state, %{mode: :manual, weather: nil, manual: manual}})
  end

  def get_mode do
    GenServer.call(__MODULE__, :get_mode)
  end


  def init(state) do
    {:ok, state}
  end

  def handle_call(:get_mode, _from, state) do
    {:reply, state.mode, state}
  end

  def handle_cast({:set_state, new_state}, _state) do
    {:noreply, new_state}
  end
end
