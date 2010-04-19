var Sonia = Class.create({
  widgets: {},
  initialize: function(host) {
    this.host = host;
    this.websocket = new WebSocket(this.host);
    this.dispatcher = new Dispatcher(this);

    this.websocket.onopen    = this.onopen.bind(this);
    this.websocket.onmessage = this.onmessage.bind(this);
    this.websocket.onclose   = this.onclose.bind(this);
    this.websocket.onerror   = this.onerror.bind(this);
  },
  onopen: function() {
    console.log("Socket opened... ");
  },
  onmessage: function(event) {
    var data = event.data;
    console.log("Received message...", data);
    this.dispatcher.dispatch(data);
  },
  onclose: function() {
    console.log("Closing socket... ");
  },
  onerror: function(event) {
    console.log("Received error:", event);
  },
  addWidget: function(widget_id, widget) {
    this.widgets[widget_id] = widget;
  }
});
