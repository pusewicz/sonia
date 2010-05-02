var Campfire = Class.create(Widget, {
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
    this.contentContainer = this.buildContent();
    this.headerContainer  = this.buildHeader();
    this.iconContainer    = this.buildWidgetIcon();

    this.container.insert(this.headerContainer);
    this.container.insert(this.iconContainer);
    this.container.insert(this.contentContainer);

    new Draggable(this.container, { scroll: window });
  },

  update: function() {
    this.contentContainer.childElements().invoke('remove');
    this.messages.reverse(false).each(function(message) {
      var cont = new Element('p');

      cont.insert(new Element('img', { src: message.avatar, width: 48, height: 48 }));
      cont.insert(new Element('div', { 'class': 'author' }).update(message.user));
      cont.insert(new Element('div', { 'class': 'message' }).update(message.body));
      cont.insert(new Element('hr' ));

      this.contentContainer.insert(cont);
    }.bind(this));
  },

  buildHeader: function() {
    return(new Element("h2", { 'class': 'handle' }).update(this.title));
  },

  buildWidgetIcon: function() {
    return(new Element("img", {src: "images/campfire/icon.png", 'class': 'campfire icon'}));
  },

  buildContent: function() {
    return(new Element("div", { 'class': "content" }));
  },
});
