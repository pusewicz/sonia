var Campfire = Class.create(Widget, {
  initialize: function($super, widget_id, config) {
    this.messages = [];
    return($super(widget_id, config));
  },
  receive: function(payload) {
    if(this.messages.length >= this.config.nitems) {
      this.messages.shift();
    }
    this.messages.push(payload);
    this.update();
  },
  update: function() {
    this.container.childElements().invoke('remove');
    this.container.appendChild(this.buildWidgetIcon());
    this.container.appendChild(this.buildHeader());
    this.messages.reverse(false).each(function(message) {
      var cont = new Element('p');
      cont.appendChild(new Element('img', { src: message.avatar, width: 48, height: 48 }));
      cont.appendChild(new Element('div', { className: 'author' }).update(message.user));
      cont.appendChild(document.createTextNode(message.body));
      cont.appendChild(new Element('hr' ));
      this.container.appendChild(cont);
    }.bind(this));
  },

  buildHeader: function() {
    return(new Element("h2").update(this.title));
  },

  buildWidgetIcon: function() {
    return(new Element("img", {src: "images/campfire.png", width: 32, height: 32, className: 'campfire icon'}));
  }
});
