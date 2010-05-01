var Widget = Class.create({
  initialize: function(widget_id, config) {
    this.parent    = $("widgets");
    this.widget_id = widget_id;
    this.title     = config.title;
    this.config    = config;
    this.buildContainer(config);
    this.update();
    this.restorePosition();
  },

  receive: function(message) {
    console.log(this.title, "received message:", message);
  },

  update: function() {
    console.log(this.title, "should redraw");
  },

  buildContainer: function(config) {
    this.container = new Element("div", {id: this.widget_id, 'class': "widget " + config.name});
    this.parent.appendChild(this.container);
  },

  savePosition: function() {
    var position = { left: this.container.getStyle('left'), top: this.container.getStyle('top') };
    Cookie.set(this.cookieKey("position"), JSON.stringify(position));
  },

  restorePosition: function() {
    try {
      var position = JSON.parse(Cookie.get(this.cookieKey("position")));
      this.container.setStyle(position);
    } catch(err) {
      console.error("Cound not set restore position", err);
    }
  },

  cookieKey: function(attr) {
    return(this.widget_id + "_" + attr);
  }
});
