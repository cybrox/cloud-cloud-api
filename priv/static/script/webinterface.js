function sendConfigurationRequest(parameters) {
  console.log("Sending updates to server!");

  $.ajax({
    type: "POST",
    url: "/config",
    data: JSON.stringify(parameters),
    contentType: "application/json",
    dataType: 'json'
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

function setOffDisplay() {
  sendConfigurationRequest({ mode: 0 });
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

    // Show webinterface content
    $('#content').css('opacity', '1');
  });
});
