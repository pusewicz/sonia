var Sonia = Class.create();

Sonia.prototype = {
  initialize: function(host) {
    this.host = host;
    this.websocket = new WebSocket(this.host);
    this.dispatcher = new Dispatcher(this);

    this.websocket.onopen    = this.onopen.bind(this);
    this.websocket.onmessage = this.onmessage.bind(this);
    this.websocket.onclose   = this.onclose.bind(this);
    this.websocket.onerror   = this.onerror.bind(this);
  },
  
  onopen    : function() {
      console.log("Socket opened... ");
  },
  onmessage : function(event) {
      var data = event.data;
      console.log("Received message...", data);
      this.dispatcher.dispatch(data);
      // this.websocket.close();
  },
  onclose   : function() {
      console.log("Closing socket... ");
  },
  onerror   : function(event) {
      console.log("Received error:", event);
  }
}

var Dispatcher = Class.create({
    initialize: function(sonia) {
        this.sonia = sonia;
        this.twitter = false;
    },
    
    dispatch: function(data) {
        var payload = JSON.parse(data);
        
        if(payload.message) {
            var message = payload.message;
            console.log("Dispatching", message.payload, "to", message.widget);
            this.twitter.receive(message.payload);
        } else if(payload.setup) {
            var widgets = payload.setup;
            // TODO: Setup widgets
            widgets.each(function(payload) {
                var widget = payload.widget;
                var config = payload.config;
                
                // TODO: Create real logic
                this.twitter = new Twitter(config);
            }.bind(this));
        }
    }
});

var Twitter = Class.create({
    initialize: function(config) {
        console.log("Building Twitter with", config.title);
        this.title = config.title;
        this.max_items = config.nitems;
        this.messages = [];
        this.element = "article[widget=twitter]";
    },
    
    receive: function(message) {
        if(this.messages.length >= this.max_items) {
            this.messages.shift();
        }
        
        this.messages.push(message);
        this.update();
    },
    
    update: function() {
        // remove existing messages
        $$(this.element + ' p').invoke('remove');

        this.messages.each(function(message) {
            var cont = new Element('p');
            cont.appendChild(new Element('a', { href: 'http://www.twitter.com/' + message.user, class: 'author' }).update(message.user));
            cont.appendChild(new Element('img', { src: message.profile_image_url }));
            cont.appendChild(document.createTextNode(message.text));            
            $$(this.element)[0].appendChild(cont);
        }.bind(this));
    }
});
