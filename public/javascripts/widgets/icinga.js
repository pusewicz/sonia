var Icinga = Class.create(Widget, {
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
    new Draggable(this.container, { handle: this.container.down(".handle") });
    this.messages.each(function(message) {
      var cont = new Element('p', { id: message.id});

      icinga_count = new Element('span', { className: 'count '  + message.status.replace(" ", "_").toLowerCase()});
      icinga_count.appendChild(document.createTextNode(message.count));
      cont.appendChild(icinga_count);

      icinga_status = new Element('span', { className: "status " + message.status.replace(" ", "_").toLowerCase()});
      icinga_status.appendChild(document.createTextNode(message.status));
      cont.appendChild(icinga_status);

      this.container.appendChild(cont);
      // new Effect.Pulsate(this.container, { pulses: 2, duration: 1 });
    }.bind(this));
  },
  buildWidgetIcon: function() {
    return(new Element("img", {src: "images/icinga.png", width: 32, height: 32, className: 'icinga icon'}));
  },
  buildHeader: function() {
    return(new Element("h2", { 'class': 'handle' }).update(this.title));
  }
});
