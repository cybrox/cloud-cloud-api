function sendConfigurationRequest(parameters) {
  console.log("Sending updates to server!");
  sendSocketUpdate(parameters);

  $.ajax({
    type: "POST",
    url: "/config",
    data: JSON.stringify(parameters),
    contentType: "application/json",
    dataType: 'json'
  });
}

function setOffDisplay() {
  sendConfigurationRequest({ mode: 0 });
}

function setWeatherDisplay(weather, intensity) {
  sendConfigurationRequest({
    mode: 1,
    weather: weather,
    intensity: intensity
  });
}

function setManualDisplay(color, pulse) {
  sendConfigurationRequest({
    mode: 2,
    color: color,
    pulse: pulse
  });
}

function setWebinterfaceMode(mode, initial) {
  if (mode == "weather") {
    if (initial) {
      $('#color-select').hide();
      $('#color-preview').hide();
    } else {
      $('#color-select').fadeOut('fast');
      $('#color-preview').fadeOut('fast');
    }
    $('#mode-w').addClass('active');
    $('#mode-m').removeClass('active');
    $('#mode-o').removeClass('active');
    if (!initial) setWeatherDisplay(0, 0);
  }

  if (mode == "manual") {
    $('#color-select').fadeIn('fast');
    $('#color-preview').fadeIn('fast');
    $('#mode-w').removeClass('active');
    $('#mode-m').addClass('active');
    $('#mode-o').removeClass('active');
    if (!initial) setManualDisplay(getColorSliders(), 0);
  }

  if (mode == "off") {
    if (initial) {
      $('#color-select').hide();
      $('#color-preview').hide();
    } else {
      $('#color-select').fadeOut('fast');
      $('#color-preview').fadeOut('fast');
    }
    $('#mode-w').removeClass('active');
    $('#mode-m').removeClass('active');
    $('#mode-o').addClass('active');
    if (!initial) setOffDisplay();
  }
}

function getColorSliders() {
  var r = $('#color-r').val();
  var g = $('#color-g').val();
  var b = $('#color-b').val();

  return r + ',' + g + ',' + b;
}

function setColorSliders(color) {
  var colors = color.split(',');
  $('#color-r').val(colors[0]).change();
  $('#color-g').val(colors[1]).change();
  $('#color-b').val(colors[2]).change();
}

function updatePreview(color) {
  $('#color-preview').css('background', 'rgba(' + color + ',1)');
}

function sendDeviceReset() {
  console.log("Sending reset to server!");

  $.ajax({
    type: "POST",
    url: "/reset"
  });
}

function showUpdateWindow() {
  $('#update-picker').show();
}

function sendSocketUpdate(parameters) {
  if (window.ws === undefined) return;

  var payload = {
    type: 'state',
    data: parameters
  }
  ws.send(JSON.stringify(payload));
}


$(document).ready(function() {
  // Set up rangeslider sliders
  var willDebounceChange = false
  $('input[type="range"]').rangeslider({polyfill: false});

  // Load configuration from server
  $.get("/config", function(payload){
    configuration = JSON.parse(payload);

    // Set mode and range sliders to server value
    setWebinterfaceMode(configuration.mode, true);

    // Set range sliders to color value
    if (configuration.manual.color) {
      setColorSliders(configuration.manual.color);
      updatePreview(configuration.manual.color);
    }

    // Set up listener for slider changes
    $('input[type="range"]').change(function() {
      if (willDebounceChange == false) {
        updatePreview(getColorSliders());
        setManualDisplay(getColorSliders(), 0);
      }

      willDebounceChange = true;
      window.setTimeout(function() { willDebounceChange = false; }, 500);
    });

    // Set up button actions
    $('#mode-w').click(function() { setWebinterfaceMode('weather', false); });
    $('#mode-m').click(function() { setWebinterfaceMode('manual', false); });
    $('#mode-o').click(function() { setWebinterfaceMode('off', false); });

    // Set up footer actions
    $('#reset').click(function()  { sendDeviceReset(); });
    $('#update').click(function() { showUpdateWindow(); });

    // Show webinterface content
    $('#content').css('opacity', '1');
  });

  // Set up websocket connection for persistent updates
  window.ws = new WebSocket("ws://localhost:6662");

  window.ws.onopen = function() { console.log('Opened socket connection'); }

  window.ws.onmessage = function(event) {
    try {
      var information = event.data;
      var payload = JSON.parse(information);
      console.log('Changing webinterface state!');
    } catch(e) {
      console.log('Received invalid socket information!');
      return;
    }

    if (payload.type == "state") {
      var mode = payload.data.mode;

      if (mode == 0) {
        setWebinterfaceMode("off");
        return;
      }

      if (mode == 1) {
        setWebinterfaceMode("weather");
        return;
      }

      if (mode == 2) {
        setWebinterfaceMode("manual");
        setColorSliders(payload.data.color);
        return;
      }
    }
  }
});
