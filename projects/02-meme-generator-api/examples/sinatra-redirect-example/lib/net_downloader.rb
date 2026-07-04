# frozen_string_literal: true

class NetDownloader
  def call(url)
    URI.open(url).read
  end
end
