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
    this.messages.each(function(message) {
      var cont = new Element('p', { id: message.id});

      icinga_count = new Element('span', { className: 'count' });
      icinga_count.appendChild(document.createTextNode(message.count));
      cont.appendChild(icinga_count);

      icinga_status = new Element('span', { className: "status " + message.status.replace(" ", "_").toLowerCase()});
      icinga_status.appendChild(document.createTextNode(message.status));
      cont.appendChild(icinga_status);

      this.container.appendChild(cont);
    }.bind(this));
  },
  buildWidgetIcon: function() {
    return(new Element("img", {width: 32, height: 32, className: 'icinga_icon'}));
  },
  buildHeader: function() {
    return(new Element("h2").update(this.title));
  }
});
