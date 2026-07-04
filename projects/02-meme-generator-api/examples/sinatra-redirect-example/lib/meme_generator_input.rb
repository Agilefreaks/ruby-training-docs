# frozen_string_literal: true

class MemeGeneratorInput
  attr_reader :image_url, :text

  def initialize(image_url, text)
    @image_url = image_url
    @text = text
  end

  def missing_image_url?
    image_url.nil? || image_url.empty?
  end

  def missing_text?
    text.nil? || text.empty?
  end

  def self.from_json(json)
    image_url = json.dig('meme', 'image_url')
    text = json.dig('meme', 'text')
    new(image_url, text)
  end
end
