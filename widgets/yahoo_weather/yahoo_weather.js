var YahooWeather = Class.create(Widget, {
  initialize: function($super, widget_id, config) {
    this.weather = {};
    return($super(widget_id, config));
  },

  handlePayload: function(payload) {
    this.weather = payload;
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
    this.iconContainer.setAttribute('src', this.iconPath(this.weather.condition.code));
    this.descriptionContainer.update(this.weather.condition.text);
    this.temperatureContainer.update(this.formatTemperature(this.weather.condition.temp, this.weather.units.temperature));
  },

  buildContent: function() {
    var container = new Element("div", { 'class': 'content' });
    this.descriptionContainer = new Element("div", { 'class': 'text' }).update("NA");
    this.temperatureContainer = new Element("div", { 'class': 'temperature' }).update(this.formatTemperature("NA", this.config.units));

    container.insert(this.descriptionContainer);
    container.insert(this.temperatureContainer);
    return(container);
  },

  formatTemperature: function(temp, unit) {
    return(temp + "&deg;" + (unit[0].toUpperCase() == "C" ? "C" : "F"));
  },

  buildIcon: function() {
    return(new Element("img", {
      src    : this.iconPath("na"),
      'class': 'yahoo_weather icon'
    }));
  },

  iconPath: function(code) {
    return("/images/yahoo_weather/" + code + ".png")
  },

  buildHeader: function() {
    return(new Element("h2", { 'class': 'handle' }).update(this.title));
  }
});
