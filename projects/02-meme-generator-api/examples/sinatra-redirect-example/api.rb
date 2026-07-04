# frozen_string_literal: true

require 'sinatra'
require 'mini_magick'
require_relative 'lib/net_downloader'
require_relative 'lib/meme_generator_input'

configure do
  set :download, NetDownloader.new
end

get '/redirect' do
  redirect '/memes/meme2.jpg', 307
end

post '/memes' do
  body = request.body.read
  halt 400 if body.empty?

  errors = []
  parsed_body = JSON.parse(body)
  input = MemeGeneratorInput.from_json(parsed_body)

  errors << "Missing image url" if input.missing_image_url?
  errors << "Missing text" if input.missing_text?

  unless errors.empty?
    halt 400, { "Content-Type" => "application/json" }, { errors: errors }.to_json
  end

  image = MiniMagick::Image.read(settings.download(input.image_url))
  image.combine_options do |c|
    c.gravity "center"
    c.draw "text 0,200 '#{input.text}'"
    c.undercolor "White"
    c.fill "Black"
    c.font 'Liberation-Sans'
    c.pointsize "60"
  end
  file_name = SecureRandom.uuid
  image.write("./images/#{file_name}.jpeg")

  redirect "/memes/#{file_name}.jpeg", 303
end

# This is just for demo purposes
#  you should not use unsanitized parameters provided by user to access file paths
get '/memes/:file' do
  path = "#{File.dirname(__FILE__)}/images/#{params[:file]}"
  send_file(path)
end
