# cloud-cloud-server
Cloud-based server for controlling the cloud-cloud.

### Protocol flow
* The cloud-cloud connects to the cloud-cloud API via `ws://` on `device_port` (_6661_)
* The cloud-cloud is expected to send the `auth_secret` to the server (_cloud-my-butt_)
* When this "handshake" has been successful, the cloud-cloud API will send `ok`
* Right after sending the `ok` packet, the server will also send its current state
* After this, the API will send information to the cloud-cloud, whenever changes occur. The device only needs to ensure that connection is established, all display information will be broadcasted as packets from the server.

Here is an example protocol flow of a client registering, performing a valid handshake, receiving initial state information, sending a ping and then receiving some further state information:
```
<connection established>
C > cloud-my-butt
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

### Todo
- Make weather fetcher actually call dispatcher

----
**note**: _cloud_ == _butt_ 
