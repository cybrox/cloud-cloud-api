defmodule Cloud.Weather do

  alias Cloud.Model.DisplayWeather, as: W

  @moduledoc """
  Represents weather state as fetched from the internet
  """


  def get_weather_for_code(200), do: %W{weather: 6, intensity: 1} # thunderstorm with light rain
  def get_weather_for_code(201), do: %W{weather: 6, intensity: 3} # thunderstorm with rain
  def get_weather_for_code(202), do: %W{weather: 6, intensity: 5} # thunderstorm with heavy rain
  def get_weather_for_code(210), do: %W{weather: 6, intensity: 4} # light thunderstorm
  def get_weather_for_code(211), do: %W{weather: 6, intensity: 5} # thunderstorm
  def get_weather_for_code(212), do: %W{weather: 6, intensity: 7} # heavy thunderstorm
  def get_weather_for_code(221), do: %W{weather: 6, intensity: 9} # ragged thunderstorm
  def get_weather_for_code(230), do: %W{weather: 6, intensity: 1} # thunderstorm with light drizzle
  def get_weather_for_code(231), do: %W{weather: 6, intensity: 3} # thunderstorm with drizzle
  def get_weather_for_code(232), do: %W{weather: 6, intensity: 5} # thunderstorm with heavy drizzle
  def get_weather_for_code(300), do: %W{weather: 5, intensity: 1} # light intensity drizzle
  def get_weather_for_code(301), do: %W{weather: 5, intensity: 3} # drizzle
  def get_weather_for_code(302), do: %W{weather: 5, intensity: 5} # heavy intensity drizzle
  def get_weather_for_code(310), do: %W{weather: 5, intensity: 3} # light intensity drizzle rain
  def get_weather_for_code(311), do: %W{weather: 5, intensity: 0} # drizzle rain
  def get_weather_for_code(312), do: %W{weather: 5, intensity: 5} # heavy intensity drizzle rain
  def get_weather_for_code(313), do: %W{weather: 5, intensity: 5} # shower rain and drizzle
  def get_weather_for_code(314), do: %W{weather: 5, intensity: 7} # heavy shower rain and drizzle
  def get_weather_for_code(321), do: %W{weather: 5, intensity: 2} # shower drizzle
  def get_weather_for_code(500), do: %W{weather: 5, intensity: 3} # light rain
  def get_weather_for_code(501), do: %W{weather: 5, intensity: 5} # moderate rain
  def get_weather_for_code(502), do: %W{weather: 5, intensity: 7} # heavy intensity rain
  def get_weather_for_code(503), do: %W{weather: 5, intensity: 8} # very heavy rain
  def get_weather_for_code(504), do: %W{weather: 5, intensity: 9} # extreme rain
  def get_weather_for_code(511), do: %W{weather: 7, intensity: 5} # freezing rain
  def get_weather_for_code(520), do: %W{weather: 5, intensity: 2} # light intensity shower rain
  def get_weather_for_code(521), do: %W{weather: 5, intensity: 3} # shower rain
  def get_weather_for_code(522), do: %W{weather: 5, intensity: 6} # heavy intensity shower rain
  def get_weather_for_code(531), do: %W{weather: 5, intensity: 7} # ragged shower rain
  def get_weather_for_code(600), do: %W{weather: 7, intensity: 4} # light snow
  def get_weather_for_code(601), do: %W{weather: 7, intensity: 5} # snow
  def get_weather_for_code(602), do: %W{weather: 7, intensity: 7} # heavy snow
  def get_weather_for_code(611), do: %W{weather: 7, intensity: 2} # sleet
  def get_weather_for_code(612), do: %W{weather: 7, intensity: 3} # shower sleet
  def get_weather_for_code(615), do: %W{weather: 7, intensity: 3} # light rain and snow
  def get_weather_for_code(616), do: %W{weather: 7, intensity: 4} # rain and snow
  def get_weather_for_code(620), do: %W{weather: 7, intensity: 4} # light shower snow
  def get_weather_for_code(621), do: %W{weather: 7, intensity: 5} # shower snow
  def get_weather_for_code(622), do: %W{weather: 7, intensity: 6} # heavy shower snow
  def get_weather_for_code(701), do: %W{weather: 8, intensity: 2} # mist
  def get_weather_for_code(711), do: %W{weather: 8, intensity: 4} # smoke
  def get_weather_for_code(721), do: %W{weather: 8, intensity: 6} # haze
  def get_weather_for_code(731), do: %W{weather: 8, intensity: 4} # sand, dust whirls
  def get_weather_for_code(741), do: %W{weather: 8, intensity: 4} # fog
  def get_weather_for_code(751), do: %W{weather: 8, intensity: 4} # sand
  def get_weather_for_code(761), do: %W{weather: 8, intensity: 3} # dust
  def get_weather_for_code(762), do: %W{weather: 8, intensity: 8} # volcanic ash
  def get_weather_for_code(771), do: %W{weather: 9, intensity: 6} # squalls
  def get_weather_for_code(781), do: %W{weather: 9, intensity: 9} # tornado
  def get_weather_for_code(800), do: %W{weather: 3, intensity: 9} # clear sky
  def get_weather_for_code(801), do: %W{weather: 3, intensity: 7} # few clouds
  def get_weather_for_code(802), do: %W{weather: 4, intensity: 0} # scattered clouds
  def get_weather_for_code(803), do: %W{weather: 4, intensity: 0} # broken clouds
  def get_weather_for_code(804), do: %W{weather: 4, intensity: 0} # overcast clouds
  def get_weather_for_code(900), do: %W{weather: 9, intensity: 9} # tornado
  def get_weather_for_code(901), do: %W{weather: 9, intensity: 9} # tropical storm
  def get_weather_for_code(902), do: %W{weather: 9, intensity: 9} # hurricane
  def get_weather_for_code(903), do: %W{weather: 3, intensity: 5} # cold
  def get_weather_for_code(904), do: %W{weather: 3, intensity: 5} # hot
  def get_weather_for_code(905), do: %W{weather: 3, intensity: 5} # windy
  def get_weather_for_code(906), do: %W{weather: 6, intensity: 7} # hail
  def get_weather_for_code(951), do: %W{weather: 3, intensity: 8} # calm
  def get_weather_for_code(952), do: %W{weather: 9, intensity: 1} # light breeze
  def get_weather_for_code(953), do: %W{weather: 9, intensity: 1} # gentle breeze
  def get_weather_for_code(954), do: %W{weather: 9, intensity: 2} # moderate breeze
  def get_weather_for_code(955), do: %W{weather: 9, intensity: 3} # fresh breeze
  def get_weather_for_code(956), do: %W{weather: 9, intensity: 4} # strong breeze
  def get_weather_for_code(957), do: %W{weather: 9, intensity: 5} # high wind, near gale
  def get_weather_for_code(958), do: %W{weather: 9, intensity: 6} # gale
  def get_weather_for_code(959), do: %W{weather: 9, intensity: 6} # severe gale
  def get_weather_for_code(960), do: %W{weather: 9, intensity: 7} # storm
  def get_weather_for_code(961), do: %W{weather: 9, intensity: 8} # violent storm
  def get_weather_for_code(962), do: %W{weather: 9, intensity: 9} # hurricane

end
