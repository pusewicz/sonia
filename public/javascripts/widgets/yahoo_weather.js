var YahooWeather = Class.create(Widget, {
  initialize: function($super, widget_id, config) {
    this.weather = {};
    return($super(widget_id, config));
  },
  receive: function(payload) {
    this.weather = payload;
    this.update();
  },
  update: function() {
    this.container.childElements().invoke('remove');
    if(this.weather.condition) {
      this.container.appendChild(this.buildWidgetIcon());
      this.container.appendChild(this.buildHeader());
      this.container.appendChild(this.buildWeather());
    }
  },
  buildWeather: function() {
    var box = new Element("div", { 'class': 'content' });
    var text = new Element("div", { 'class': 'text' }).update(this.weather.condition.text);
    var temperature = new Element("div", { 'class': 'temperature' });
    temperature.update(this.weather.condition.temp + "&deg;" + this.weather.units.temperature);
    box.appendChild(text);
    box.appendChild(temperature);
    return(box);
  },
  buildWidgetIcon: function() {
    return(new Element("img", {
      src       : "/images/yahoo_weather/" + this.weather.condition.code + ".png",
      className : 'yahoo_weather icon'
    }));
  },
  buildHeader: function() {
    return(new Element("h2").update(this.title));
  }
});
