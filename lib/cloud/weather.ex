defmodule Cloud.Weather do

  defstruct code: nil


  def get_weather_for_code(200), do: # thunderstorm with light rain
  def get_weather_for_code(201), do: # thunderstorm with rain
  def get_weather_for_code(202), do: # thunderstorm with heavy rain
  def get_weather_for_code(210), do: # light thunderstorm
  def get_weather_for_code(211), do: # thunderstorm
  def get_weather_for_code(212), do: # heavy thunderstorm
  def get_weather_for_code(221), do: # ragged thunderstorm
  def get_weather_for_code(230), do: # thunderstorm with light drizzle
  def get_weather_for_code(231), do: # thunderstorm with drizzle
  def get_weather_for_code(232), do: # thunderstorm with heavy drizzle
  def get_weather_for_code(300), do: # light intensity drizzle
  def get_weather_for_code(301), do: # drizzle
  def get_weather_for_code(302), do: # heavy intensity drizzle
  def get_weather_for_code(310), do: # light intensity drizzle rain
  def get_weather_for_code(311), do: # drizzle rain
  def get_weather_for_code(312), do: # heavy intensity drizzle rain
  def get_weather_for_code(313), do: # shower rain and drizzle
  def get_weather_for_code(314), do: # heavy shower rain and drizzle
  def get_weather_for_code(321), do: # shower drizzle
  def get_weather_for_code(500), do: # light rain
  def get_weather_for_code(501), do: # moderate rain
  def get_weather_for_code(502), do: # heavy intensity rain
  def get_weather_for_code(503), do: # very heavy rain
  def get_weather_for_code(504), do: # extreme rain
  def get_weather_for_code(511), do: # freezing rain
  def get_weather_for_code(520), do: # light intensity shower rain
  def get_weather_for_code(521), do: # shower rain
  def get_weather_for_code(522), do: # heavy intensity shower rain
  def get_weather_for_code(531), do: # ragged shower rain
  def get_weather_for_code(600), do: # light snow
  def get_weather_for_code(601), do: # snow
  def get_weather_for_code(602), do: # heavy snow
  def get_weather_for_code(611), do: # sleet
  def get_weather_for_code(612), do: # shower sleet
  def get_weather_for_code(615), do: # light rain and snow
  def get_weather_for_code(616), do: # rain and snow
  def get_weather_for_code(620), do: # light shower snow
  def get_weather_for_code(621), do: # shower snow
  def get_weather_for_code(622), do: # heavy shower snow
  def get_weather_for_code(701), do: # mist
  def get_weather_for_code(711), do: # smoke
  def get_weather_for_code(721), do: # haze
  def get_weather_for_code(731), do: # sand, dust whirls
  def get_weather_for_code(741), do: # fog
  def get_weather_for_code(751), do: # sand
  def get_weather_for_code(761), do: # dust
  def get_weather_for_code(762), do: # volcanic ash
  def get_weather_for_code(771), do: # squalls
  def get_weather_for_code(781), do: # tornado
  def get_weather_for_code(800), do: # clear sky
  def get_weather_for_code(801), do: # few clouds
  def get_weather_for_code(802), do: # scattered clouds
  def get_weather_for_code(803), do: # broken clouds
  def get_weather_for_code(804), do: # overcast clouds
  def get_weather_for_code(900), do: # tornado
  def get_weather_for_code(901), do: # tropical storm
  def get_weather_for_code(902), do: # hurricane
  def get_weather_for_code(903), do: # cold
  def get_weather_for_code(904), do: # hot
  def get_weather_for_code(905), do: # windy
  def get_weather_for_code(906), do: # hail
  def get_weather_for_code(951), do: # calm
  def get_weather_for_code(952), do: # light breeze
  def get_weather_for_code(953), do: # gentle breeze
  def get_weather_for_code(954), do: # moderate breeze
  def get_weather_for_code(955), do: # fresh breeze
  def get_weather_for_code(956), do: # strong breeze
  def get_weather_for_code(957), do: # high wind, near gale
  def get_weather_for_code(958), do: # gale
  def get_weather_for_code(959), do: # severe gale
  def get_weather_for_code(960), do: # storm
  def get_weather_for_code(961), do: # violent storm
  def get_weather_for_code(962), do: # hurricane

end
