defmodule Cloud.Model.Weather do

  @moduledoc """
  Represents weather state as fetched from the internet
  """


  defstruct code: nil


  def get_weather_for_code(200), do: 0 # thunderstorm with light rain
  def get_weather_for_code(201), do: 0 # thunderstorm with rain
  def get_weather_for_code(202), do: 0 # thunderstorm with heavy rain
  def get_weather_for_code(210), do: 0 # light thunderstorm
  def get_weather_for_code(211), do: 0 # thunderstorm
  def get_weather_for_code(212), do: 0 # heavy thunderstorm
  def get_weather_for_code(221), do: 0 # ragged thunderstorm
  def get_weather_for_code(230), do: 0 # thunderstorm with light drizzle
  def get_weather_for_code(231), do: 0 # thunderstorm with drizzle
  def get_weather_for_code(232), do: 0 # thunderstorm with heavy drizzle
  def get_weather_for_code(300), do: 0 # light intensity drizzle
  def get_weather_for_code(301), do: 0 # drizzle
  def get_weather_for_code(302), do: 0 # heavy intensity drizzle
  def get_weather_for_code(310), do: 0 # light intensity drizzle rain
  def get_weather_for_code(311), do: 0 # drizzle rain
  def get_weather_for_code(312), do: 0 # heavy intensity drizzle rain
  def get_weather_for_code(313), do: 0 # shower rain and drizzle
  def get_weather_for_code(314), do: 0 # heavy shower rain and drizzle
  def get_weather_for_code(321), do: 0 # shower drizzle
  def get_weather_for_code(500), do: 0 # light rain
  def get_weather_for_code(501), do: 0 # moderate rain
  def get_weather_for_code(502), do: 0 # heavy intensity rain
  def get_weather_for_code(503), do: 0 # very heavy rain
  def get_weather_for_code(504), do: 0 # extreme rain
  def get_weather_for_code(511), do: 0 # freezing rain
  def get_weather_for_code(520), do: 0 # light intensity shower rain
  def get_weather_for_code(521), do: 0 # shower rain
  def get_weather_for_code(522), do: 0 # heavy intensity shower rain
  def get_weather_for_code(531), do: 0 # ragged shower rain
  def get_weather_for_code(600), do: 0 # light snow
  def get_weather_for_code(601), do: 0 # snow
  def get_weather_for_code(602), do: 0 # heavy snow
  def get_weather_for_code(611), do: 0 # sleet
  def get_weather_for_code(612), do: 0 # shower sleet
  def get_weather_for_code(615), do: 0 # light rain and snow
  def get_weather_for_code(616), do: 0 # rain and snow
  def get_weather_for_code(620), do: 0 # light shower snow
  def get_weather_for_code(621), do: 0 # shower snow
  def get_weather_for_code(622), do: 0 # heavy shower snow
  def get_weather_for_code(701), do: 0 # mist
  def get_weather_for_code(711), do: 0 # smoke
  def get_weather_for_code(721), do: 0 # haze
  def get_weather_for_code(731), do: 0 # sand, dust whirls
  def get_weather_for_code(741), do: 0 # fog
  def get_weather_for_code(751), do: 0 # sand
  def get_weather_for_code(761), do: 0 # dust
  def get_weather_for_code(762), do: 0 # volcanic ash
  def get_weather_for_code(771), do: 0 # squalls
  def get_weather_for_code(781), do: 0 # tornado
  def get_weather_for_code(800), do: 0 # clear sky
  def get_weather_for_code(801), do: 0 # few clouds
  def get_weather_for_code(802), do: 0 # scattered clouds
  def get_weather_for_code(803), do: 0 # broken clouds
  def get_weather_for_code(804), do: 0 # overcast clouds
  def get_weather_for_code(900), do: 0 # tornado
  def get_weather_for_code(901), do: 0 # tropical storm
  def get_weather_for_code(902), do: 0 # hurricane
  def get_weather_for_code(903), do: 0 # cold
  def get_weather_for_code(904), do: 0 # hot
  def get_weather_for_code(905), do: 0 # windy
  def get_weather_for_code(906), do: 0 # hail
  def get_weather_for_code(951), do: 0 # calm
  def get_weather_for_code(952), do: 0 # light breeze
  def get_weather_for_code(953), do: 0 # gentle breeze
  def get_weather_for_code(954), do: 0 # moderate breeze
  def get_weather_for_code(955), do: 0 # fresh breeze
  def get_weather_for_code(956), do: 0 # strong breeze
  def get_weather_for_code(957), do: 0 # high wind, near gale
  def get_weather_for_code(958), do: 0 # gale
  def get_weather_for_code(959), do: 0 # severe gale
  def get_weather_for_code(960), do: 0 # storm
  def get_weather_for_code(961), do: 0 # violent storm
  def get_weather_for_code(962), do: 0 # hurricane

end
