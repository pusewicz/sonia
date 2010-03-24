var Sonia = Class.create();

Sonia.prototype = {
  initialize: function(host) {
    this.host = host;
    this.websocket = new WebSocket(this.host);
    this.dispatcher = new Dispatcher();

    this.websocket.onopen    = this.onopen.bind(this);
    this.websocket.onmessage = this.onmessage.bind(this);
    this.websocket.onclose   = this.onclose.bind(this);
    this.websocket.onerror   = this.onerror.bind(this);
  },
  
  onopen    : function() {
      console.log("Socket opened... ");
  },
  onmessage : function(event) {
      var data = event.data;
      console.log("Received message...");
      this.dispatcher.dispatch(data);
      this.websocket.close();
  },
  onclose   : function() {
      console.log("Closing socket... ");
  },
  onerror   : function(event) {
      console.log("Received error:", event);
  }
}

var Dispatcher = Class.create();

Dispatcher.prototype = {
    initialize: function(sonia) {
        this.sonia = sonia;
    },
    dispatch: function(data) {
        var payload = JSON.parse(data);
        
        if(payload.message) {
            var message = payload.message;
            // TODO: Deliver message to widget
            console.log("Dispatching", message.payload, "to", message.widget);
        } else if(payload.setup) {
            var setup = payload.setup;
            // TODO: Setup widgets
            console.log("Setting up", setup.widget, "with", setup.payload);
        }
    }
}