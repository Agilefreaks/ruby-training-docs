# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'

require_relative '../api'
