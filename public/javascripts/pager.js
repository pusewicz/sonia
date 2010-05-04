var Pager = Class.create({
  initialize: function(sonia) {
    this.sonia = sonia;
    this.pages = [];
    this.currentPage = 0;
    this.build();
  },

  addWidgetToCurrentPage: function(widgetSha) {
    if(!this.pages[this.currentPage]) {
      this.pages[this.currentPage] = [];
    }

    this.getCurrentPage().push(widgetSha);
    this.update();
    // TODO: Remove this in final version
    if(this.currentPage == 0) this.currentPage++;
  },

  build: function() {
    this.buildPager();
  },

  update: function() {
    this.buildPager();
    this.showOnlyCurrentPageWidgets();
  },

  buildPager: function() {
    if(this.pagerContainer) { $(this.pagerContainer).remove(); }
    this.pagerContainer = new Element("ul", { id: "pager" });
    this.pages.each(function(page) {
      this.pagerContainer.insert(new Element("li", { 'class': (this.getCurrentPage() == page) ? 'current' : '' }).update("&bull;"));
    }.bind(this));
    $("widgets").insert(this.pagerContainer);
  },

  showOnlyCurrentPageWidgets: function() {
    this.currentPageWidgets().each(function(el) {
      console.log("Current wudget", el);
      $(el).show();
    }.bind(this));

    this.notCurrentPageWidgets().each(function(el) {
      console.log("NotCurrent wudget", el);
      $(el).hide();
    }.bind(this));
  },

  currentPageWidgets: function() {
    return(this.getCurrentPage().collect(function(el) {
      return $(el);
    }.bind(this)));
  },

  notCurrentPageWidgets: function() {
    console.log("Pages", this.pages);
    console.log("CurrPage", this.currentPage);
    var nonCurrentPages = this.pages.findAll(function(el) {
      el != this.getCurrentPage();
    }.bind(this));

    console.log("Noncurrentpages:", nonCurrentPages);

    return(nonCurrentPages.flatten().collect(function(el) {
      return $(el);
    }));
  },

  getCurrentPage: function() {
    return(this.pages[this.currentPage]);
  }
});
