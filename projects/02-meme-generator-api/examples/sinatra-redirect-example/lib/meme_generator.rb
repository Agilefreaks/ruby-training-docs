# frozen_string_literal: true

class MemeGenerator
  def initialize(download)
    @download = download
  end

  def call(meme_generator_input)
    image = MiniMagick::Image.read(@download.call(meme_generator_input.image_url))
    image.combine_options do |c|
      c.gravity "center"
      c.draw "text 0,200 '#{meme_generator_input.text}'"
      c.undercolor "White"
      c.fill "Black"
      c.font 'Liberation-Sans'
      c.pointsize "60"
    end
    file_name = SecureRandom.uuid
    image.write("./images/#{file_name}.jpeg")
    file_name
  end
end
