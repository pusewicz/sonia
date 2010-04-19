var Widget = Class.create({
  initialize: function(widget_id, config) {
    this.parent    = $("widgets");
    this.widget_id = widget_id;
    this.title     = config.title;
    this.config    = config;
    this.buildContainer(config);
    this.update();
  },

  receive: function(message) {
    console.log(this.title, "received message: ", message);
  },

  update: function() {
    console.log(this.title, "should redraw");
  },

  buildContainer: function(config) {
    this.container = new Element("div", {id: this.widget_id, className: "widget " + config.name});
    this.parent.appendChild(this.container);
  }
});
