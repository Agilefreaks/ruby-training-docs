# frozen_string_literal: true

require 'sinatra/base'
require './app/models/meme'

class ApplicationController < Sinatra::Base
  configure do
    set :views, 'app/views'
  end

  get '/' do
    erb :index
  end

  get '/memes' do
    erb :memes_form
  end

  enable :sessions

  post '/create_meme' do
    @meme = Meme.new
    @meme.image_url = params[:image_url]
    @meme.text = params[:text]
    @meme.create

    redirect "/display_meme/#{@meme.file_name}", 303
  end

  get '/display_meme/:file_name' do
    send_file(Meme.file_path(params[:file_name]))
  end
end
