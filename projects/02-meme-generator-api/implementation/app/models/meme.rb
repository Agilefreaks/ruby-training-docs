# frozen_string_literal: true

require 'mini_magick'
require 'open-uri'

class Meme
  attr_accessor :image_url, :text, :file_name

  def create
    save_image
    add_text
  end

  def self.file_path(file_name)
    "app/images/#{file_name}"
  end

  private

  def save_image
    uri = URI.parse(image_url)
    @file_name = 'image1.jpg'
    @meme_path = "app/images/#{@file_name}"
    uri.open do |image|
      File.open(@meme_path, 'wb') do |file|
        file.write(image.read)
      end
    end
  end

  def add_text
    image = MiniMagick::Image.new(@meme_path)
    image.combine_options do |c|
      c.gravity 'center'
      c.draw "text 0,0 \'#{text}\'"
      c.undercolor 'White'
      c.fill 'Black'
      c.font 'Helvetica'
      c.pointsize '60'
    end
  end
end
