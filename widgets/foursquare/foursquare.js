var Foursquare = Class.create(Widget, {
  initialize: function($super, widget_id, config) {
    this.checkins = [];
    return($super(widget_id, config));
  },
  handlePayload: function(payload) {
    this.checkins = [];
    payload.each(function(checkin) {
      this.checkins.push(checkin);
    }.bind(this));
    this.update();
  },
  build: function() {
    this.checkinsContainer = this.buildCheckins();
    this.headerContainer = this.buildHeader();

    this.container.insert(this.headerContainer);
    this.container.insert(this.buildWidgetIcon());
    this.container.insert(this.checkinsContainer);

    new Draggable(this.container, { scroll: window });
  },
  update: function() {
    this.checkinsContainer.childElements().invoke('remove');
    this.checkins.each(function(checkin) {
      var cont = new Element('p', { id: checkin.id});

      cont.appendChild(new Element('img', { src: checkin.avatar_url, height:48, width:48}));
      cont.appendChild(new Element('div', {'class':'author'}).update(checkin.name));
      cont.appendChild(new Element('div').update(checkin.venue + " " + checkin.when + " ago"));
      cont.insert(new Element('hr' ));

      this.checkinsContainer.insert(cont);
      // new Effect.Pulsate(this.container, { pulses: 2, duration: 1 });
    }.bind(this));
  },
  buildWidgetIcon: function() {
    return(new Element("img", {src: "images/foursquare/icon.png", width: 32, height: 32, className: 'foursquare icon'}));
  },
  buildHeader: function() {
    return(new Element("h2", { 'class': 'handle' }).update(this.title));
  },
  buildCheckins: function() {
    return(new Element("div", { 'class': 'checkins' }));
  }
});
