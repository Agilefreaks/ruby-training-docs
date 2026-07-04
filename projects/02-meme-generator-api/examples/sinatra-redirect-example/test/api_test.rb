# frozen_string_literal: true

require 'test_helper'
require 'mini_magick'

class ApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    result = Sinatra::Application
    result.set(:download) do |_uri|
      File.binread(File.expand_path('fixtures/original.jpeg', __dir__))
    end
    result
  end

  def test_rediret_will_return_the_temp_redirect_status
    get '/redirect'
    follow_redirect!

    expected_image = File.binread(File.expand_path('../images/meme2.jpg', __dir__))

    assert_equal expected_image, last_response.body
  end

  def test_post_memes_will_return_permanent_redirect
    post_memes()

    assert_equal 303, last_response.status
  end

  def test_post_memes_with_empty_body_will_return_bad_request
    post '/memes'

    assert last_response.bad_request?
  end

  def test_post_memes_will_redirect_to_the_generated_meme
    post_memes(image_url: 'http://image.url', text: 'Mornings are best')
    follow_redirect!

    actual_image = MiniMagick::Image.open(File.expand_path('fixtures/meme.jpeg', __dir__))
    image = MiniMagick::Image.read(last_response.body)

    assert_equal actual_image, image
  end

  def test_post_memes_concurrent_request
    request_fiber = lambda do |text|
      Fiber.new do
        session = Rack::Test::Session.new(app)
        post_memes(image_url: "http://image.random", text: text, session: session)
        Fiber.yield :written

        session.follow_redirect!
        MiniMagick::Image.read(session.last_response.body)
      end
    end

    request1 = request_fiber.call('My text is the best')
    request1.resume
    request1_image = request1.resume

    request2 = request_fiber.call('NO! My text is the best')
    request2.resume
    request2_image = request2.resume

    request1 = request_fiber.call('My text is the best')
    request2 = request_fiber.call('NO! My text is the best')

    request1.resume
    request2.resume

    assert_equal request1_image, request1.resume
    assert_equal request2_image, request2.resume
  end

  private

  def post_memes(image_url: nil, text: nil, session: self)
    body = {
      meme: {
        image_url: image_url,
        text: text
      }
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }
    session.post '/memes', body.to_json, headers
  end
end
