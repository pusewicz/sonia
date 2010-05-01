var Github = Class.create(Widget, {
  initialize: function($super, widget_id, config) {
    this.messages = [];
    return($super(widget_id, config));
  },
  receive: function(payload) {
    this.messages = payload;
    this.update();
  },
  update: function() {
    this.container.childElements().invoke('remove');
    this.container.appendChild(this.buildWidgetIcon());
    this.container.appendChild(this.buildHeader());
    this.messages.reverse(false).each(function(message) {
      var cont = new Element('p');
      cont.appendChild(new Element('img', { src: "http://www.gravatar.com/avatar/" + message.gravatar + ".jpg", width: 48, height: 48 }));
      cont.appendChild(new Element('div', { className: 'author' }).update(message.author));
      var commit_message = new Element('div', { className: 'commit' }).update(
        'Commited <span class="commit_message">' + message.message + '</span> to <span class="commit_repository">' + message.repository.name + '</span>'
      );
      cont.appendChild(commit_message);
      cont.appendChild(new Element('hr' ));
      this.container.appendChild(cont);
    }.bind(this));
  },

  buildHeader: function() {
    return(new Element("h2").update(this.title));
  },

  buildWidgetIcon: function() {
    return(new Element("img", {src: "images/github.png", className: 'github icon'}));
  }
});

