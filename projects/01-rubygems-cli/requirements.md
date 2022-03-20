# CLI for Searching Ruby Gems

## Purpose

Create a command-line interface that will help with discovering Ruby Gems.

## About RubyGems

Ruby Gems are independent ruby programs or libraries that can be installed and used inside your own program.
They can be browsed at [rubygems.org](https://rubygems.org) and they offer a series of APIs that can
be found [here](https://guides.rubygems.org/rubygems-org-api/).


## What to implement

### Search

#### cli.rb search <keyword>

This should display a list of all gems that contain in “name” of “info” the keyword specified.

The name should have precedence vs info.

```bash
cli.rb show <gem name>
```

This should display the details of the gem specified by _<gem name>_.

### General consideration

What to return:

- Return `0` exit code if the program runs successfully
- Return `nonzero` exit codes when the program encountered an error

In case you are wondering how to return status codes in Ruby [here](https://www.honeybadger.io/blog/how-to-exit-a-ruby-program/) is a good tutorial about this.


## Features

### Week 1:

- Build an MVP connecting to the Ruby Gems and executing a query
- Add the Show one gem

### Week 2:
- Add an option to order the search. Eg: `--recent-first` or `--most-downloads-first`
- Add 2 days caching: write in local cache detail about searched gems and when someone needs to show one gem that was already shown in the last 2 days retrieve it from local DB/cache and not from API

