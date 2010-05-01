WebSocket.__swfLocation = "WebSocketMain.swf";
$(document).observe("dom:loaded", function() {
  if ("WebSocket" in window) {
    console.log("WebSocket supported.");
    var sonia = new Sonia("ws://localhost:8080");
  } else {
      console.log("WebSocket not supported.");
    }
});
