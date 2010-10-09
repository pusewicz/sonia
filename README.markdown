# Sonia

Sonia is an Awesome Office Dashboard.

## What is Sonia?

![Sonia](http://soniaapp.com/images/screenshot.png)

<script type="text/javascript" src="http://www.ohloh.net/p/482920/widgets/project_users_logo.js"></script>

Sonia allows you to set up a dashboard with information that is important to you. Think [Panic's Status Board](http://www.panic.com/blog/2010/03/the-panic-status-board/).

At the moment, Sonia comes with [Campfire](http://campfirenow.com/), [Foursquare](http://foursquare.com/), [Github](http://github.com/), [Icinga](http://www.icinga.org/), RSS, [TfL](http://www.tfl.gov.uk/), [Twitter](http://www.twitter.com/) and [Yahoo! Weather](http://weather.yahoo.com/) widgets.

Go ahead and have a look at [the demo](http://demo.soniaapp.com:8080/).

Thanks to Aaalex, you can watch a nice screencast introduction to Sonia at [RubyPulse](http://www.rubypulse.com/episode-0.38_sonia.html).

# BYOW

Bring Your Own Widgets! It's so easy to create your own widgets! Have a look at [example](http://github.com/pusewicz/sonia/tree/master/widgets/) ones.

## Requirements

* Ruby 1.9.2
* Bundler gem `gem install bundler`

## Quick Start

    $ git clone http://github.com/pusewicz/sonia.git

    # If you are using RVM (Ruby Version Manager)
    $ rvm 1.9.1
    $ rvm gemset create sonia

    # Run Sonia
    $ cd sonia
    $ bundle install
    $ ./bin/sonia start --config example/config.yml

## More Information

Have a look in the [Wiki](http://wiki.github.com/pusewicz/sonia/).

Initial documentation is available on [YardDoc](http://yardoc.org/docs/pusewicz-sonia).

Follow Sonia on [Twitter](http://www.twitter.com/soniaappcom).

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Stats

<script type="text/javascript" src="http://www.ohloh.net/p/482920/widgets/project_basic_stats.js"></script>
<script type="text/javascript" src="http://www.ohloh.net/p/482920/widgets/project_languages.js"></script>

## Copyright

Copyright (c) 2010 Piotr Usewicz. See LICENSE for details.
