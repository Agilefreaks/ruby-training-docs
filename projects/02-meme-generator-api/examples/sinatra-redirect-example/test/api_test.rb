# frozen_string_literal: true

require 'test_helper'

class ApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_rediret_will_return_the_temp_redirect_status
    get '/redirect'

    assert last_response.redirect?
  end
end
