var Twitter = Class.create(Widget, {
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
    new Draggable($(this.container));
    this.container.childElements().invoke('remove');
    this.container.appendChild(this.buildWidgetIcon());
    this.container.appendChild(this.buildHeader());
    this.messages.reverse(false).each(function(message) {
      var cont = new Element('p');
      cont.appendChild(new Element('img', { src: message.profile_image_url }));
      cont.appendChild(new Element('a', { href: 'http://www.twitter.com/' + message.user, className: 'author' }).update(message.user));
      cont.appendChild(document.createTextNode(message.text.replace(/http.*\w/i,"")));
      cont.appendChild(new Element('hr' ))
      this.container.appendChild(cont);
      // new Effect.Pulsate(this.container, { pulses: 2, duration: 1 });
    }.bind(this));
  },

  buildHeader: function() {
    return(new Element("h2").update(this.title));
  },

  buildWidgetIcon: function() {
    return(new Element("img", { src: "images/twitter.png", width: 32, height: 32, className: 'twitter icon'}));
  }
});
