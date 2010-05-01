WebSocket.__swfLocation = "WebSocketMain.swf";

$(document).observe("dom:loaded", function() {
  if ("WebSocket" in window) {
    console.log("WebSocket supported.");
    window.sonia = new Sonia("ws://localhost:8080");

    Event.observe(window, 'beforeunload', function() {
      window.sonia.saveChanges();
    });
  } else {
      console.log("WebSocket not supported.");
    }
});


