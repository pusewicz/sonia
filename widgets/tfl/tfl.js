var Tfl = Class.create(Widget, {
  initialize: function($super, widget_id, config) {
    this.messages = [];
    return($super(widget_id, config));
  },

  handlePayload: function(payload) {
    this.messages = [];
    payload.each(function(message) {
      this.messages.push(message);
    }.bind(this));
  },

  build: function() {
    this.contentContainer = this.buildContent();
    this.headerContainer  = this.buildHeader();
    this.iconContainer    = this.buildWidgetIcon();

    this.container.insert(this.headerContainer);
    this.container.insert(this.iconContainer);
    this.container.insert(this.contentContainer);

    this.makeDraggable();
  },

  update: function() {
    this.contentContainer.childElements().invoke('remove');

    this.messages.each(function(message) {
      var cont = new Element('p', { id: message.id });

      cont.insert(new Element('span', { 'class': 'station' }).update(message.name.replace("&amp;", "&")));
      cont.insert(new Element('span', { 'class': "status " + message.status.replace(" ", "_")}).update(message.status));

      this.contentContainer.insert(cont);
    }.bind(this));
  },

  buildWidgetIcon: function() {
    return(new Element("img", {src: "images/tfl/icon.png",  'class': 'tfl icon'}));
  },

  buildHeader: function() {
    return(new Element("h2", { 'class': 'handle' }).update(this.title));
  },

  buildContent: function() {
    return(new Element("div", { 'class': "content" }));
  },
});
