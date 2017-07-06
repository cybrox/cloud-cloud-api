defmodule Cloud.Weather do

  @moduledoc """
  Represents weather state as fetched from the internet
  """


  def get_weather_for_code(200), do: %{weather: 6, intensity: 1} # thunderstorm with light rain
  def get_weather_for_code(201), do: %{weather: 6, intensity: 3} # thunderstorm with rain
  def get_weather_for_code(202), do: %{weather: 6, intensity: 5} # thunderstorm with heavy rain
  def get_weather_for_code(210), do: %{weather: 6, intensity: 4} # light thunderstorm
  def get_weather_for_code(211), do: %{weather: 6, intensity: 5} # thunderstorm
  def get_weather_for_code(212), do: %{weather: 6, intensity: 7} # heavy thunderstorm
  def get_weather_for_code(221), do: %{weather: 6, intensity: 9} # ragged thunderstorm
  def get_weather_for_code(230), do: %{weather: 6, intensity: 1} # thunderstorm with light drizzle
  def get_weather_for_code(231), do: %{weather: 6, intensity: 3} # thunderstorm with drizzle
  def get_weather_for_code(232), do: %{weather: 6, intensity: 5} # thunderstorm with heavy drizzle
  def get_weather_for_code(300), do: %{weather: 5, intensity: 1} # light intensity drizzle
  def get_weather_for_code(301), do: %{weather: 5, intensity: 3} # drizzle
  def get_weather_for_code(302), do: %{weather: 5, intensity: 5} # heavy intensity drizzle
  def get_weather_for_code(310), do: %{weather: 5, intensity: 3} # light intensity drizzle rain
  def get_weather_for_code(311), do: %{weather: 5, intensity: 0} # drizzle rain
  def get_weather_for_code(312), do: %{weather: 5, intensity: 5} # heavy intensity drizzle rain
  def get_weather_for_code(313), do: %{weather: 5, intensity: 5} # shower rain and drizzle
  def get_weather_for_code(314), do: %{weather: 5, intensity: 7} # heavy shower rain and drizzle
  def get_weather_for_code(321), do: %{weather: 5, intensity: 2} # shower drizzle
  def get_weather_for_code(500), do: %{weather: 5, intensity: 3} # light rain
  def get_weather_for_code(501), do: %{weather: 5, intensity: 5} # moderate rain
  def get_weather_for_code(502), do: %{weather: 5, intensity: 7} # heavy intensity rain
  def get_weather_for_code(503), do: %{weather: 5, intensity: 8} # very heavy rain
  def get_weather_for_code(504), do: %{weather: 5, intensity: 9} # extreme rain
  def get_weather_for_code(511), do: %{weather: 7, intensity: 5} # freezing rain
  def get_weather_for_code(520), do: %{weather: 5, intensity: 2} # light intensity shower rain
  def get_weather_for_code(521), do: %{weather: 5, intensity: 3} # shower rain
  def get_weather_for_code(522), do: %{weather: 5, intensity: 6} # heavy intensity shower rain
  def get_weather_for_code(531), do: %{weather: 5, intensity: 7} # ragged shower rain
  def get_weather_for_code(600), do: %{weather: 7, intensity: 4} # light snow
  def get_weather_for_code(601), do: %{weather: 7, intensity: 5} # snow
  def get_weather_for_code(602), do: %{weather: 7, intensity: 7} # heavy snow
  def get_weather_for_code(611), do: %{weather: 7, intensity: 2} # sleet
  def get_weather_for_code(612), do: %{weather: 7, intensity: 3} # shower sleet
  def get_weather_for_code(615), do: %{weather: 7, intensity: 3} # light rain and snow
  def get_weather_for_code(616), do: %{weather: 7, intensity: 4} # rain and snow
  def get_weather_for_code(620), do: %{weather: 7, intensity: 4} # light shower snow
  def get_weather_for_code(621), do: %{weather: 7, intensity: 5} # shower snow
  def get_weather_for_code(622), do: %{weather: 7, intensity: 6} # heavy shower snow
  def get_weather_for_code(701), do: %{weather: 8, intensity: 2} # mist
  def get_weather_for_code(711), do: %{weather: 8, intensity: 4} # smoke
  def get_weather_for_code(721), do: %{weather: 8, intensity: 6} # haze
  def get_weather_for_code(731), do: %{weather: 8, intensity: 4} # sand, dust whirls
  def get_weather_for_code(741), do: %{weather: 8, intensity: 4} # fog
  def get_weather_for_code(751), do: %{weather: 8, intensity: 4} # sand
  def get_weather_for_code(761), do: %{weather: 8, intensity: 3} # dust
  def get_weather_for_code(762), do: %{weather: 8, intensity: 8} # volcanic ash
  def get_weather_for_code(771), do: %{weather: 9, intensity: 6} # squalls
  def get_weather_for_code(781), do: %{weather: 9, intensity: 9} # tornado
  def get_weather_for_code(800), do: %{weather: 3, intensity: 9} # clear sky
  def get_weather_for_code(801), do: %{weather: 3, intensity: 7} # few clouds
  def get_weather_for_code(802), do: %{weather: 4, intensity: 0} # scattered clouds
  def get_weather_for_code(803), do: %{weather: 4, intensity: 0} # broken clouds
  def get_weather_for_code(804), do: %{weather: 4, intensity: 0} # overcast clouds
  def get_weather_for_code(900), do: %{weather: 9, intensity: 9} # tornado
  def get_weather_for_code(901), do: %{weather: 9, intensity: 9} # tropical storm
  def get_weather_for_code(902), do: %{weather: 9, intensity: 9} # hurricane
  def get_weather_for_code(903), do: %{weather: 3, intensity: 5} # cold
  def get_weather_for_code(904), do: %{weather: 3, intensity: 5} # hot
  def get_weather_for_code(905), do: %{weather: 3, intensity: 5} # windy
  def get_weather_for_code(906), do: %{weather: 6, intensity: 7} # hail
  def get_weather_for_code(951), do: %{weather: 3, intensity: 8} # calm
  def get_weather_for_code(952), do: %{weather: 9, intensity: 1} # light breeze
  def get_weather_for_code(953), do: %{weather: 9, intensity: 1} # gentle breeze
  def get_weather_for_code(954), do: %{weather: 9, intensity: 2} # moderate breeze
  def get_weather_for_code(955), do: %{weather: 9, intensity: 3} # fresh breeze
  def get_weather_for_code(956), do: %{weather: 9, intensity: 4} # strong breeze
  def get_weather_for_code(957), do: %{weather: 9, intensity: 5} # high wind, near gale
  def get_weather_for_code(958), do: %{weather: 9, intensity: 6} # gale
  def get_weather_for_code(959), do: %{weather: 9, intensity: 6} # severe gale
  def get_weather_for_code(960), do: %{weather: 9, intensity: 7} # storm
  def get_weather_for_code(961), do: %{weather: 9, intensity: 8} # violent storm
  def get_weather_for_code(962), do: %{weather: 9, intensity: 9} # hurricane
  def get_weather_for_code(_),   do: %{weather: 3, intensity: 9} # unknown (-> clear sky)

end
