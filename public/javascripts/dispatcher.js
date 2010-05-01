var Dispatcher = Class.create({
  initialize: function(sonia) {
    this.sonia = sonia;
  },
  dispatch: function(data) {
    var json = JSON.parse(data);

    if(json.message) {
      if(json.message.widget && json.message.widget_id && json.message.payload) {
        try {
          this.sonia.widgets[json.message.widget_id].onReceive(json.message.payload);
        } catch(err) {
          console.error("Could not deliver message", json.message);
        }
      } else {
        console.log("Missing data in message message:", json.message);
      }
    } else if(json.setup) {
      var widgets = json.setup;
      widgets.each(function(payload) {
        var widget    = payload.widget;
        var widget_id = payload.widget_id;
        var config    = payload.config;
        if(widget && widget_id && config) {
          var widget_object = eval("new " + widget + "(widget_id, config)");
          this.sonia.addWidget(widget_id, widget_object);
        } else {
          console.log("Missing data in setup message:", json.setup);
        }
      }.bind(this));
    }
  }
});
