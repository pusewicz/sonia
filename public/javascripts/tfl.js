var Tfl = Class.create(Widget, {
  initialize: function($super, widget_id, config) {
    this.messages = [];
    return($super(widget_id, config));
  },
  receive: function(payload) {
    this.messages = [];
    payload.each(function(message) {
      this.messages.push(message);
    }.bind(this));
    this.update();
  },
  update: function() {
    this.container.childElements().invoke('remove');
    this.container.appendChild(this.buildWidgetIcon());
    this.container.appendChild(this.buildHeader());
    this.messages.each(function(message) {
      var cont = new Element('p', { id: message.id});

      station = new Element('span', { className: 'station' });
      station.appendChild(document.createTextNode(message.name.replace("&amp;", "&")));
      cont.appendChild(station);

      stat = new Element('span', { className: "status " + message.status.replace(" ", "_")});
      stat.appendChild(document.createTextNode(message.status));
      cont.appendChild(stat);

      this.container.appendChild(cont);
      // new Effect.Pulsate(this.container, { pulses: 2, duration: 1 });
    }.bind(this));
  },
  buildWidgetIcon: function() {
    return(new Element("img", {src: "images/tfl.png", width: 32, height: 32, className: 'tfl icon'}));
  },
  buildHeader: function() {
    return(new Element("h2").update(this.title));
  }
});
