# cloud-cloud-api
This is the server side api implementation for our cloud connected cloud, a project inspired by Sparkfun's [cloud-cloud](https://learn.sparkfun.com/tutorials/led-cloud-connected-cloud) but reimagined to using a custom server software that potentially allows implementing a lot more features in the future.

Basically, instead of handling everything on the ESP32 and adding an app for manual control via a third party service, we control data abstraction and manual control on the server side, providing a mobile-friendly webinterface. The weather data used is coming from [openweathermap](https://openweathermap.org/)

A note on the state of this project:
* The software is fully functional, at least as far as we are aware of
* The software will be deployed in-house, so security is not a factor
* The software is completely untested. - Because I'm lazy.

### The idea
The server is running constantly, its state is reset when it is restarted. The _cloud-cloud_ will connect to the server via a websocket connection, perform a pseudo-handshake and will receive display information broadcasted from the server from then on. Currently supported operation modes are `off`, `weather` and `manual`.

If you want to run this on a server somewhere out in the open, you might want to proxy the `http` endpoint behind nginx, serving it via `https` and use `wss` for the socket connection.

### Protocol flow
* The cloud-cloud connects to the cloud-cloud API via `ws://` on `device_port`
* The cloud-cloud is expected to send the `auth_secret` to the server
* When this "handshake" has been successful, the cloud-cloud API will send `ok`
* Right after sending the `ok` packet, the server will also send its current state
* After this, the API will send information to the cloud-cloud, whenever changes occur. The device only needs to ensure that connection is established, all display information will be broadcasted as packets from the server.

Here is an example protocol flow of a client registering, performing a valid handshake, receiving initial state information, sending a ping and then receiving some further state information:
```
<connection established>
C > auth-secret
S > ok
S > [cc:0:?:?]
C > ping
S > pong
S > [cc:2:255,65,174:0]
S > [cc:2:255,162,174:0]
S > [cc:2:69,162,174:0]
S > [cc:2:69,162,245:0]
```

### Protocol packets
The display packets transmitted from the server contain the following information:
* `mode` Mode `0` is for off, this is the default when the server is started

* `mode` Mode `1` is for weather information
  * `weather` The current weather code, `1 - 9`
  * `intensity` The current weather intensity `1 - 9` (can be float for _sunrise_/_sunset_)

* `mode` Mode `2` is for manual color setting
  * `color` The RGB value of the custom color to set `r,g,b`
  * `pulse` Light pulsing intensity `1 - 9`

### Protocol format
Aside the text ping packets described below (not the ping layer ping packets), all packets sent will have the following format: `[cc:<mode>:<param1>:<param2>]`. Color information will be sent as `r,g,b`. Unknown or unused parameters will be filled with `?`.    

Example off packet: `[cc:0:?:?]`   
Example weather packet: `[cc:1:2:0]`   
Example color packet: `[cc:2:255,255,255:0]`

### Ensuring connection
The Server offers a permanent ping/pong handler in order for the client to check its connection. The client can send a ping via websocket with an arbitrary cookie at any time and should receive a pong from the server immediately, if it is still connected.    
The client can either send a proper websocket ping frame with an appropriate cookie, or just send a text packet with the content `ping` and should receive a text packet with the content `pong`.

### Weather states
* `1` - Sunrise
* `2` - Sunset
* `3` - Clear Sky
* `4` - Cloudy Sky
* `5` - Rainy
* `6` - Storm
* `7` - Snow
* `8` - Mist/Smoke/Sand/Dust
* `9` - Windy

### Webinterface
Yes, the whole [cloud-to-butt](https://github.com/panicsteve/cloud-to-butt) thing is still funny. No, we're not immature!

![screen](http://s.cybrox.eu/s/20170707084638.png)
