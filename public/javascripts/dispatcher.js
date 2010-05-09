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
          console.error("Could not deliver message", json.message, err);
        }
      } else {
        console.log("Missing data in message message:", json.message);
      }
    } else if(json.setup) {
      this.sonia.addWidgets(json.setup);
    }
  }
});
