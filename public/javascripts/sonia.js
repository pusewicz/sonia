var Sonia = Class.create({
  initialize: function(host) {
    this.widgets    = {};
    this.host       = host;
    this.websocket  = new WebSocket(this.host);
    this.dispatcher = new Dispatcher(this);

    this.websocket.onopen    = this.onopen.bind(this);
    this.websocket.onmessage = this.onmessage.bind(this);
    this.websocket.onclose   = this.onclose.bind(this);
    this.websocket.onerror   = this.onerror.bind(this);

    //this.pager = new Pager(this);
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

  getWidgets: function() {
    return(this.widgets);
  },

  addWidgets: function(setup) {
    setup.each(function(payload) {
      var widget    = payload.widget;
      var widget_id = payload.widget_id;
      var config    = payload.config;
      if(widget && widget_id && config) {
        var widget_object = eval("new " + widget + "(widget_id, config)");
        this.addWidget(widget_id, widget_object);
      } else {
        console.log("Missing data in setup message:", json.setup);
      }
    }.bind(this));
  },

  addWidget: function(widget_id, widget) {
    this.widgets[widget_id] = widget;
    //this.pager.addWidgetToCurrentPage(widget_id);
  },

  saveChanges: function() {
    $H(this.widgets).each(function(pair) {
      pair.value.savePosition();
    }.bind(this));
  }
});
