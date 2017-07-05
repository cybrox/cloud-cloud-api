function sendConfigurationRequest(parameters) {
  console.log(parameters);
  return;
  $.ajax({
    type: "POST",
    url: "/config",
    data: parameters
  });
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
    $('#color-select').hide();
    $('#mode-w').addClass('active');
    $('#mode-m').removeClass('active');
    if (!initial) setWeatherDisplay(0, 0);
  }

  if (mode == "manual") {
    $('#color-select').show();
    $('#mode-w').removeClass('active');
    $('#mode-m').addClass('active');
    if (!initial) setManualDisplay(getColorSliders(), 0);
  }
}

function getColorSliders() {
  var r = $('#color-r').val();
  var g = $('#color-g').val();
  var b = $('#color-b').val();

  return r + ',' + g + ',' + b;
}


$(document).ready(function() {
  // Set up rangeslider sliders
  $('input[type="range"]').rangeslider({polyfill: false});

  // Set up button actions
  $('#mode-w').click(function() { setWebinterfaceMode('weather', false); });
  $('#mode-m').click(function() { setWebinterfaceMode('manual', false); });

  // Load configuration from server
  $.get("/config", function(payload){
    configuration = JSON.parse(payload);

    // Set mode and range sliders to server value
    setWebinterfaceMode(configuration.mode, true);

    // Show webinterface content
    $('#content').css('opacity', '1');

    
  });
});
