var Twitter = Class.create(Widget, {
  initialize: function($super, widget_id, config) {
    this.messages = [];
    return($super(widget_id, config));
  },

  handlePayload: function(payload) {
    if(this.messages.length >= this.config.nitems) {
      this.messages.shift();
    }
    this.messages.push(payload);
  },

  build: function() {
    this.messagesContainer = this.buildMessages();
    this.headerContainer = this.buildHeader();

    this.container.insert(this.headerContainer);
    this.container.insert(this.buildWidgetIcon());
    this.container.insert(this.messagesContainer);

    this.makeDraggable();
  },

  update: function() {
    this.messagesContainer.childElements().invoke('remove');
    this.messages.reverse(false).each(function(message) {
      var cont = new Element('p');
      cont.insert(new Element('img', { src: message.profile_image_url }));
      cont.insert(new Element('div', { 'class': 'author' }).update(message.user));
      cont.insert(new Element('div', { 'class': 'message' }).update(message.text.replace(/http.*\w/ig,"[link]")));
      cont.insert(new Element('hr' ));

      this.messagesContainer.insert(cont);
    }.bind(this));
  },

  buildHeader: function() {
    return(new Element("h2", { 'class': 'handle' }).update(this.title));
  },

  buildWidgetIcon: function() {
    return(new Element("img", { src: "images/twitter/icon.png", 'class': 'twitter icon'}));
  },

  buildMessages: function() {
    return(new Element("div", { 'class': 'messages' }));
  }
});
