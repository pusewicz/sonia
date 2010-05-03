var Pager = Class.create({
  initialize: function(sonia) {
    this.sonia = sonia;
    this.pages = [["sha1"], ["sha2"], ["sha3"]];
    this.currentPage = 0;
    this.build();
  },

  build: function() {
    this.buildPager();
  },

  update: function() {
    this.buildPager();
  },

  buildPager: function() {
    if(this.pager) this.pager.remove();
    this.pager = new Element("ul", { id: "pager" });
    this.pages.each(function(page) {
      this.pager.insert(new Element("li", { 'class': (this.pages[this.currentPage] == page) ? 'current' : '' }).update("&bull;"));
    }.bind(this));
    $("widgets").insert(this.pager);
  }
});
