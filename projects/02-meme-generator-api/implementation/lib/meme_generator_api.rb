# frozen_string_literal: true

require 'open-uri'

class MemeGeneratorAPI
  def self.execute(uri_string)
    uri = URI.parse(uri_string)
    image_path = './images/image1.jpg'
    uri.open do |image|
      File.open(image_path, 'wb') do |file|
        file.write(image.read)
      end
    end
  end
end
