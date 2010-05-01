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
  build: function() {
    this.container.insert(this.buildWidgetIcon());
    this.header_container = this.buildHeader();
    this.container.insert(this.header_container);
    this.messages_container = this.buildMessages();
    this.container.insert(this.messages_container);
  },
  update: function() {
    this.messages_container.childElements().invoke('remove');
    this.messages.reverse(false).each(function(message) {
      var cont = new Element('p');
      cont.insert(new Element('img', { src: message.profile_image_url }));
      cont.insert(new Element('div', { 'class': 'author' }).update(message.user));
      cont.insert(document.createTextNode(message.text.replace(/http.*\w/ig,"")));
      cont.insert(new Element('hr' ))
      this.messages_container.insert(cont);
    }.bind(this));
  },

  buildHeader: function() {
    return(new Element("h2", { 'class': 'handle' }).update(this.title));
  },

  buildWidgetIcon: function() {
    return(new Element("img", { src: "images/twitter.png", width: 32, height: 32, className: 'twitter icon'}));
  },

  buildMessages: function() {
    return(new Element("div", { 'class': 'messages' }));
  }
});
