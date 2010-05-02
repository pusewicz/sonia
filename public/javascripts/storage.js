var Storage = {
  storage: function() {
    if (typeof(localStorage) == 'undefined') {
      console.warn('Local storage not supported by this browser, using CookieStore');
      var CookieStorage = {
        set: function(name, value) {
          return(Cookie.set(name, value));
        },
        get: function(name) {
          return(Cookie.get(name));
        },
        unset: function(name) {
          return(Cookie.unset(name));
        }
      }
      return(CookieStorage);
    } else {
      console.log("localStorage supported.");
      var LocalStorage = {
        set: function(name, value) {
          return(localStorage.setItem(name, value));
        },
        get: function(name) {
          return(localStorage.getItem(name));
        },
        unset: function(name) {
          return(localStorage.removeItem(name));
        }
      }
      return(LocalStorage);
    }
  }(),
  set: function(name, value) {
    return(this.storage.set(name, JSON.stringify(value)));
  },
  get: function(name) {
    return(JSON.parse(this.storage.get(name)));
  },
  unset: function(name) {
    return(this.storage.unset(name));
  }
};
