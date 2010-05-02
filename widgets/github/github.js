var Github = Class.create(Widget, {
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

    new Draggable(this.container, { scroll: window });
  },

  update: function() {
    this.contentContainer.childElements().invoke('remove');

    this.messages.reverse(false).each(function(message) {
      var cont = new Element('p');
      cont.insert(new Element('img', { src: "http://www.gravatar.com/avatar/" + message.gravatar + ".jpg" }));
      cont.insert(new Element('div', { className: 'author' }).update(message.author));
      var commit_message = new Element('div', { className: 'commit' }).update(
        'Commited <span class="commit_message">' + message.message + '</span> to <span class="commit_repository">' + message.repository.name + '</span>'
      );
      cont.insert(commit_message);
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
    return(new Element("img", { src: "images/github/icon.png", 'class': 'github icon' }));
  }
});

