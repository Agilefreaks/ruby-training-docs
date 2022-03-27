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

This should display the details of the gem specified by _gem name_.

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
- Authenticate calls to RubyGems API (see [here](https://guides.rubygems.org/rubygems-org-api/#api-authorization) more details)
- Add an option to order or filter the search. Eg: `--most-downloads-first`, `--license LICENSE`
- Add 2 days caching: write in local cache detail about searched gems and when someone needs to show one gem that was already shown in the last 2 days retrieve it from local DB/cache and not from API


#### Week 2 Feature: Authenticate calls to RubyGems API

To implement this feature you need to create and account and then generate and API key. They explain where to find the API key [here](https://guides.rubygems.org/rubygems-org-api/#api-authorization).

Regarding your implementation, you should make it so that the API KEY is read from your local console.
That means that the API Key should _never_ be commited to Git.

You code should read the API key from env variables.
Check the file 'example-env-variables.rb'. Download it and run it locally.

When implementing this authentication to your GET calls to RubyGems make it so that you don't need to manually add this key to the headers every time you do a get.

Resources:

- https://ruby-doc.org/core-3.1.0/ENV.html
- https://www.serverlab.ca/tutorials/linux/administration-linux/how-to-set-environment-variables-in-linux/
- https://dev.to/kapilgorve/set-environment-variable-in-windows-and-wsl-linux-in-terminal-3mg4

#### Week 2 Feature: Add an option to order or filter the search

`--most-downloads-first`

Example:
`ruby cli.rb search rspec --recent-first`

Using this option means that the printed results should be displayed starting from the most downloaded one to the least downloaded one.

To implement this feature you will need a way to handle the returned result from `GET https://rubygems.org/api/v1/search.json?query=`.
That query is returning an array of hashes. Each hash contains details about one gem that matches the search string.


`--license LICENSE`

Example:
`ruby cli.rb search email --licence MIT`

This should return only the gems that have the license MIT. In case there are repositories with multiple licenses if one is MIT then they should be shown.
Please notice that `licenses` attribute is an array.

`--license LICENSE --most-downloads-first`

You should make it so that it works when giving both options.

Technical requirement:
- You should create a class named Gem that will be instantiated for each returned gem
- So after receiving the results from the API call, you will need to map this result to create an instance of the class

Example:
```ruby
results = client.search(name) # make sure results is an array of hashes
gems = results.map { |gem_data| Gem.new(gem_data) }
```

Hints:
- https://ruby-doc.org/core-3.1.0/Array.html
- https://ruby-doc.org/core-3.1.1/Enumerable.html
- Do not use metaprogramming. You can maybe as an example use `send` or `public_send`

#### Week 2 Feature: Local caching

_Please work on this only after you implemented the other features_

We want to have a local caching, that should expire in maximum 2 days.

How this will work:
- when someone is searching for a gem, first check if there is a local file containin the cache and if the cache has expired or not for that search.
- if the cache did not expired, then just return the results from the cache file, no API call should be made.
- if the cache expired, then do the API call, show the results to the user but also write down in a file the results that you get from using the API for that search term
