var Widget = Class.create({
  initialize: function(widget_id, config) {
    this.parent    = $("widgets");
    this.widget_id = widget_id;
    this.title     = config.title;
    this.config    = config;
    this.buildContainer(config);
    this.build();
    this.restorePosition();
  },

  onReceive: function(payload) {
    this.handlePayload(payload);
    this.update();
  },

  handlePayload: function(message) {
    console.log(this.title, "received message:", message);
  },

  update: function() {
    console.warn(this.title, "should redraw");
  },

  build: function() {
    console.warn(this.title, "should build it's initial structure");
  },

  buildContainer: function(config) {
    this.container = new Element("div", {id: this.widget_id, 'class': "widget " + config.name});
    this.parent.appendChild(this.container);
  },

  savePosition: function() {
    var position = { left: this.container.measure("left"), top: this.container.measure("top") };
    Storage.set(this.attrKey("position"), position);
  },

  restorePosition: function() {
    try {
      var position = Storage.get(this.attrKey("position"));
      this.container.setStyle({ left: parseInt(position.left) + "px", top: parseInt(position.top) + "px"});
    } catch(err) {
      console.warn("Cound not set restore position", err);
    }
  },

  attrKey: function(attr) {
    return(this.widget_id + "_" + attr);
  }
});
