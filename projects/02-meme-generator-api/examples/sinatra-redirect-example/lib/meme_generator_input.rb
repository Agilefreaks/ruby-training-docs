# frozen_string_literal: true

class MemeGeneratorInput
  def initialize(root)
    @root = root
  end

  def errors
    errors = []

    errors << 'Body must be a json of form: {meme: {image_url: "url", text: "text"}} (RTFM)' if @root.nil?
    return errors if errors.any?
    errors << "Missing image url" if missing_image_url?
    errors << "Missing text" if missing_text?

    errors
  end

  def valid?
    errors.empty?
  end

  def self.parse_json(text)
    parsed_body = JSON.parse(text.empty? ? '{}' : text)
    from_json(parsed_body)
  end

  def self.from_json(json)
    root = json.dig('meme')
    new(root)
  end

  def image_url = @root.dig('image_url')

  def text = @root.dig('text')

  private

  def missing_image_url?
    image_url.nil? || image_url.empty?
  end

  def missing_text?
    text.nil? || text.empty?
  end

end
