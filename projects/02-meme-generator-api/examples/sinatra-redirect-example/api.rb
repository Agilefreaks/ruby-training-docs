# frozen_string_literal: true

require 'sinatra'
require 'mini_magick'

configure do
  set :download, ->(url) { URI.open(url).read }
end

get '/redirect' do
  redirect '/memes/meme2.jpg', 307
end

post '/memes' do
  body = request.body.read
  halt 400 if body.empty?
  parsed_body = JSON.parse(body)
  image_url = parsed_body.dig('meme', 'image_url')
  text = parsed_body.dig('meme', 'text')

  image = MiniMagick::Image.read(settings.download(image_url))
  image.combine_options do |c|
    c.gravity "center"
    c.draw "text 0,200 '#{text}'"
    c.undercolor "White"
    c.fill "Black"
    c.font 'Liberation-Sans'
    c.pointsize "60"
  end
  image.write("./images/meme.jpeg")

  redirect '/memes/meme.jpeg', 303
end

# This is just for demo purposes
#  you should not use unsanitized parameters provided by user to access file paths
get '/memes/:file' do
  path = "#{File.dirname(__FILE__)}/images/#{params[:file]}"
  send_file(path)
end
