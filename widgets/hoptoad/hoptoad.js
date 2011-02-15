var Hoptoad = Class.create(Widget, {
  initialize: function($super, widget_id, config) {
    this.messages = [];
    return($super(widget_id, config));
  },

  handlePayload: function(payload) {
    this.messages = payload;
  },

  build: function() {
    this.contentContainer = this.buildContent();
    this.headerContainer  = this.buildHeader();
    this.iconContainer    = this.buildIcon();

    this.container.insert(this.headerContainer);
    this.container.insert(this.iconContainer);
    this.container.insert(this.contentContainer);

    this.makeDraggable();
  },

  update: function() {
    this.contentContainer.childElements().invoke('remove');

    this.messages.reverse(false).each(function(message) {
      var cont = new Element('p');
      if (message.errors == "0") {
          var class_errors = "no_app_errors";
      } else {
          var class_errors = "app_errors";
      }
      var app_errors = new Element('div', { className: 'app_errors' }).update(
          '<table><tr><td class="app_name">' + message.name + '</td><td class="' + class_errors + '">' + message.errors + '</td></tr></table>'
      );
      cont.insert(app_errors);
      cont.insert(new Element('hr' ));
      this.contentContainer.insert(cont);
    }.bind(this));
  },

  buildContent: function() {
    return(new Element("div", { 'class': 'content' }));
  },

  buildHeader: function() {
    return(new Element("h2", { 'class': 'handle' }).update(this.title));
  },

  buildIcon: function() {
    return(new Element("img", { src: "images/hoptoad/hoptoad-promo.png", 'class': 'hoptoad icon' }));
  }
});

