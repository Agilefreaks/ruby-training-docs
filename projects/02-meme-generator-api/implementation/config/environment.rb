# frozen_string_literal: true

ENV['SINATRA_ENV'] ||= 'development'
ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default)

require_all 'app'
