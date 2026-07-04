# frozen_string_literal: true

require 'sinatra'
require 'mini_magick'
require_relative 'lib/net_downloader'
require_relative 'lib/meme_generator_input'
require_relative 'lib/meme_generator'

set :download, NetDownloader.new

get '/redirect' do
  redirect '/memes/meme2.jpg', 307
end

post '/memes' do
  input = MemeGeneratorInput.parse_json(request.body.read)

  unless input.valid?
    halt 400, { "Content-Type" => "application/json" }, { errors: input.errors }.to_json
  end

  file_name = MemeGenerator.new(settings.download).call(input)

  redirect "/memes/#{file_name}.jpeg", 303
end

# This is just for demo purposes
#  you should not use unsanitized parameters provided by user to access file paths
get '/memes/:file' do
  path = "#{File.dirname(__FILE__)}/images/#{params[:file]}"
  send_file(path)
end
