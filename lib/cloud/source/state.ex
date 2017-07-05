defmodule Cloud.Source.State do
  use GenServer

  alias Cloud.Model.DisplayWeather
  alias Cloud.Model.DisplayManual

  @moduledoc """
  Keeper of the current cloud-cloud state.
  This is mostly influenced by the fetcher and the webinterface
  """

  def start_link() do
    GenServer.start_link(__MODULE__, %{mode: 1, weather: %DisplayWeather{}, manual: %DisplayManual{}})
  end


  def init(state) do
    {:ok, state}
  end

end
