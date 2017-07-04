# butt-butt-server
Butt-based server for controlling the butt-butt.

### Protocol flow
* The cloud-cloud connects to the cloud-cloud API via `ws://` on `device_port` (_6661_)
* The cloud-cloud is expected to send the `auth_secret` to the server (_cloud-my-butt_)
* When this "handshake" has been successful, the cloud-cloud API will send `ok`
* After this, the API will periodically send information to the cloud-cloud. The device only needs to ensure that connection is established, all display information will be broadcasted as packets from the server.

### Protocol packets
The display packets transmitted from the server contain the following information:
* `mode` This will be either `1` (_weather_) or `2` (_manual_)
* `weather` Only in _weather_ mode: The current weather code, `1` - `10`
* `color` Only in _manual_ mode: The RGB value of the custom color to set

### Ensuring connection
The Server offers a permanent ping/pong handler in order for the client to check its connection. The client can send a ping via websocket with an arbitrary cookie at any time and should receive a pong from the server immediately, if it is still connected.

----
**note**: _cloud_ == _butt_
