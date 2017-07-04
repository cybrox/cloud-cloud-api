# butt-butt-server
Butt-based server for controlling the butt-butt.

### Protocol flow
* The cloud-cloud connects to the cloud-cloud API via `ws://` on `device_port` (_6661_)
* The cloud-cloud is expected to send the `auth_secret` to the server (_cloud-my-butt_)
* When this "handshake" has been successful, the cloud-cloud API will send `ok`
* After this, the API will periodically send information to the cloud-cloud. The device only needs to ensure that connection is established, all display information will be broadcasted as packets from the server.

### Protocol packets
The display packets transmitted from the server contain the following information:
* `mode` Mode `1` is for weather information
  * `weather` The current weather code, `1 - 9`
  * `intensity` The current weather intensity `1 - 9`

* `mode` Mode `2` is for manual color setting
  * `color` The RGB value of the custom color to set `r,g,b`
  * `pulse` Light pulsing intensity `1 - 9`

### Protocol format
Aside the text ping packets described below (not the ping layer ping packets), all packets sent will have the following format: `[cc:<mode>:<param1>:<param2>]`. Color information will be sent as `r,g,b`.    
Example weather packet: `[cc:1:2:0]`   
Example color packet: `[cc:2:255,255,255:0]`

### Ensuring connection
The Server offers a permanent ping/pong handler in order for the client to check its connection. The client can send a ping via websocket with an arbitrary cookie at any time and should receive a pong from the server immediately, if it is still connected.    
The client can either send a proper websocket ping frame with an appropriate cookie, or just send a text packet with the content `ping` and should receive a text packet with the content `pong`.

### Todo
- Break websocket handling into own `one-for-all` supervision tree
- Make weather fetcher actually call dispatcher
- Implement timeout for calling dispatcher while it's awaiting connection
- Add cowboy+plug for simple webinterface

----
**note**: _cloud_ == _butt_ 
