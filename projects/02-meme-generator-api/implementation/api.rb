# frozen_string_literal: true

require './lib/meme_generator_api'

class API
  def self.run
    uri_string = 'https://blog.theclymb.com/wp-content/uploads/2016/05/shutterstock_336348722-1-1024x683.jpg'
    MemeGeneratorAPI.execute(uri_string)
  end
end

API.run

# TODO:
#   - save image file locally (get from url)
#   - add text to image
#   - redirect to image (in browser)

# Work with:
#   - Sinatra
#   - MiniMagick
#   - OpenURI
