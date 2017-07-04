defmodule Cloud.Model.DisplayWeather do
  
  @moduledoc """
  Represents display state as data understandable for our cloud-cloud
  This display state contains information about the current weather.
  """


  defstruct mode: 1, weather: nil, intensity: nil

end
