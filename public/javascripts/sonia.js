var Sonia = Class.create({
  widgets: {},
  initialize: function(host) {
    this.host = host;
    this.websocket = new WebSocket(this.host);
    this.dispatcher = new Dispatcher(this);

    this.websocket.onopen    = this.onopen.bind(this);
    this.websocket.onmessage = this.onmessage.bind(this);
    this.websocket.onclose   = this.onclose.bind(this);
    this.websocket.onerror   = this.onerror.bind(this);
  },
  onopen: function() {
    console.log("Socket opened... ");
  },
  onmessage: function(event) {
    var data = event.data;
    console.log("Received message...", data);
    this.dispatcher.dispatch(data);
  },
  onclose: function() {
    console.log("Closing socket... ");
  },
  onerror: function(event) {
    console.log("Received error:", event);
  },
  addWidget: function(widget_id, widget) {
    this.widgets[widget_id] = widget;
  }
});

var Dispatcher = Class.create({
  initialize: function(sonia) {
    this.sonia = sonia;
  },
  dispatch: function(data) {
    var json = JSON.parse(data);

    if(json.message) {
      if(json.message.widget && json.message.widget_id && json.message.payload) {
        this.sonia.widgets[json.message.widget_id].receive(json.message.payload);
      } else {
        console.log("Missing data in message message:", json.message);
      }
    } else if(json.setup) {
      var widgets = json.setup;
      widgets.each(function(payload) {
        var widget    = payload.widget;
        var widget_id = payload.widget_id;
        var config    = payload.config;
        if(widget && widget_id && config) {
          var widget_object = eval("new " + widget + "(widget_id, config)");
          this.sonia.addWidget(widget_id, widget_object);
        } else {
          console.log("Missing data in setup message:", json.setup);
        }
      }.bind(this));
    }
  }
});

var Widget = Class.create({
  initialize: function(widget_id, config) {
    this.parent    = $("widgets");
    this.widget_id = widget_id;
    this.title     = config.title;
    this.config    = config;
    this.buildContainer(config);
    this.update();
  },

  receive: function(message) {
    console.log(this.title, "received message: ", message);
  },

  update: function() {
    console.log(this.title, "should redraw");
  },

  buildContainer: function(config) {
    this.container = new Element("div", {id: this.widget_id, className: "widget " + config.name});
    this.parent.appendChild(this.container);
  }
});

var Twitter = Class.create(Widget, {
  initialize: function($super, widget_id, config) {
    this.messages = [];
    return($super(widget_id, config));
  },
  receive: function(payload) {
    if(this.messages.length >= this.config.nitems) {
      this.messages.shift();
    }
    this.messages.push(payload);
    this.update();
  },
  update: function() {
    this.container.childElements().invoke('remove');
    this.container.appendChild(this.buildWidgetIcon());
    this.container.appendChild(this.buildHeader());
    this.messages.each(function(message) {
      var cont = new Element('p');
      cont.appendChild(new Element('img', { src: message.profile_image_url, width: 48, height: 48 }));
      cont.appendChild(new Element('a', { href: 'http://www.twitter.com/' + message.user, className: 'author' }).update(message.user));
      cont.appendChild(document.createTextNode(message.text));
      cont.appendChild(new Element('hr' ))
      this.container.appendChild(cont);
    }.bind(this));
  },

  buildHeader: function() {
    return(new Element("h2").update(this.title));
  },

  buildWidgetIcon: function() {
    return(new Element("img", {width: 32, height: 32, className: 'twitter_icon'}));
  }
});

var Tfl = Class.create(Widget, {
  initialize: function($super, widget_id, config) {
    this.messages = [];
    return($super(widget_id, config));
  },
  receive: function(payload) {
    this.messages = [];
    payload.each(function(message) {
      this.messages.push(message);
    }.bind(this));
    this.update();
  },
  update: function() {
    this.container.childElements().invoke('remove');
    this.container.appendChild(this.buildWidgetIcon());
    this.container.appendChild(this.buildHeader());
    this.messages.each(function(message) {
      var cont = new Element('p', { id: message.id});

      station = new Element('span', { className: 'station' });
      station.appendChild(document.createTextNode(message.name.replace("&amp;", "&")));
      cont.appendChild(station);

      stat = new Element('span', { className: message.status.replace(" ", "_")});
      stat.appendChild(document.createTextNode(message.status));
      cont.appendChild(stat);

      this.container.appendChild(cont);
    }.bind(this));
  },
  buildWidgetIcon: function() {
    return(new Element("img", {width: 32, height: 32, className: 'tfl_icon'}));
  },
  buildHeader: function() {
    return(new Element("h2").update(this.title));
  }
});
