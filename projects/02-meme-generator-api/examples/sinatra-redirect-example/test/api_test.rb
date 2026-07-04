# frozen_string_literal: true

require 'test_helper'

class ApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_rediret_will_return_the_temp_redirect_status
    get '/redirect'
    follow_redirect!

    expected_image = File.binread(File.expand_path('../images/meme2.jpg', __dir__))

    assert_equal expected_image, last_response.body
  end

  def test_post_memes_will_return_permanent_redirect
    post '/memes', {}.to_json, { 'CONTENT_TYPE' => 'application/json' }

    assert_equal 303, last_response.status
  end

  def test_post_memes_with_empty_body_will_return_bad_request
    post '/memes'

    assert last_response.bad_request?
  end
end
