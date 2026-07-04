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
    post '/memes'

    assert_equal 303, last_response.status
  end
end
