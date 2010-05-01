var Icinga = Class.create(Widget, {
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
    this.iconContainer    = this.buildIcon();

    this.container.insert(this.headerContainer);
    this.container.insert(this.iconContainer);
    this.container.insert(this.contentContainer);

    new Draggable(this.container, { scroll: window });
  },

  update: function() {
    this.contentContainer.childElements().invoke('remove');
    this.messages.each(function(message) {
      var cont = new Element('p', { id: message.id});

      var icinga_count = new Element('span', { 'class': 'count '  + message.status.replace(" ", "_").toLowerCase()});
      icinga_count.insert(document.createTextNode(message.count));
      cont.insert(icinga_count);

      var icinga_status = new Element('span', { 'class': "status " + message.status.replace(" ", "_").toLowerCase()});
      icinga_status.insert(document.createTextNode(message.status));
      cont.insert(icinga_status);

      this.contentContainer.insert(cont);
    }.bind(this));
  },

  buildContent: function() {
    return(new Element("div", { 'class': "content" }));
  },

  buildIcon: function() {
    return(new Element("img", { src: "images/icinga.png", 'class': 'icinga icon' }));
  },

  buildHeader: function() {
    return(new Element("h2", { 'class': 'handle' }).update(this.title));
  }
});
