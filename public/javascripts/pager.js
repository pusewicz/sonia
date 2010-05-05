var Pager = Class.create({
  initialize: function(sonia) {
    this.sonia = sonia;
    this.pages = [];
    this.currentPage = 0;
    this.build();
    setInterval(this.changePage.bind(this), 20 * 100);
  },

  addWidgetToCurrentPage: function(widgetSha) {
    if(!this.pages[this.currentPage]) {
      this.pages[this.currentPage] = [];
      this.pageCount = this.pages.size();
    }

    this.getCurrentPage().push(widgetSha);
    this.update();
    // TODO: Remove this in final version
    if(this.pages[0].size() == 2) this.currentPage++;
  },

  changePage: function() {
    var currPage = this.currentPage;
    if(++this.currentPage >= this.pageCount) {
      this.currentPage = 0;
    }

    this.transitionToNewPage(currPage, this.currentPage);
    this.update();
  },

  transitionToNewPage: function(fromIdx, toIdx) {
    currentPage = this.pages[fromIdx];
    nextPage = this.pages[toIdx];

    var viewportWidth = document.viewport.getWidth();
    // Prepare next page widgets

    var nextWidgets = nextPage.collect(function(el) {
      return this.sonia.widgets[el];
    }, this);

    var currentWidgets = currentPage.collect(function(el) {
      return this.sonia.widgets[el];
    }, this);

    nextWidgets.each(function(w) {
      var destX = w.x + viewportWidth;
      var widget = $(w.widget_id);
      console.log("Setting", widget, "to", destX);
      widget.setStyle({left: destX + "px"});
      console.log("Morphing next", widget, "to", w.x);
      widget.morph("left:" + w.x + "px", {
        duration: 0.7,
        transition: 'easeInOutExpo',
        propertyTransitions: {
          top: 'spring', left: 'easeInOutCirc'
        }
      });
    });

    currentWidgets.each(function(w) {
      var destX = -(w.x + viewportWidth);
      var widget = $(w.widget_id);
      console.log("Morphing current", widget, "to", destX);
      widget.morph("left:" + destX + "px", {
        duration: 0.7,
        transition: 'easeInOutExpo',
        propertyTransitions: {
          top: 'spring', left: 'easeInOutCirc'
        }
      });
    });
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
    }, this);
    $("widgets").insert(this.pagerContainer);
  },

  showOnlyCurrentPageWidgets: function() {
    this.currentPageWidgets().each(function(el) {
      //$(el).show();
    }, this);

    this.notCurrentPageWidgets().each(function(el) {
      //$(el).hide();
    }, this);
  },

  currentPageWidgets: function() {
    return(this.getCurrentPage().collect(function(el) {
      return $(el);
    }, this));
  },

  notCurrentPageWidgets: function() {
    var nonCurrentPages = this.pages.findAll(function(el) {
      return(el != this.getCurrentPage());
    }, this);

    return(nonCurrentPages.flatten().collect(function(el) {
      return $(el);
    }));
  },

  getCurrentPage: function() {
    return(this.pages[this.currentPage]);
  }
});
