# frozen_string_literal: true

require 'open-uri'
require 'mini_magick'
require 'sinatra'

require './lib/post_image_with_sinatra'

class MemeGeneratorAPI
  def self.execute(uri_string, text)
    # save image as file locally
    uri = URI.parse(uri_string)
    image_path = './images/image1.jpg'
    uri.open do |image|
      File.open(image_path, 'wb') do |file|
        file.write(image.read)
      end
    end

    # add text to image
    image = MiniMagick::Image.new('./images/image1.jpg')
    image.combine_options do |c|
      c.gravity 'center'
      c.draw "text 0,0 \'#{text}\'"
      c.undercolor 'White'
      c.fill 'Black'
      c.font 'Helvetica'
      c.pointsize '60'
    end

    # post image
    PostImageWithSinatra.run!
  end
end
