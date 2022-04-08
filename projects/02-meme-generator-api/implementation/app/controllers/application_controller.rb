# frozen_string_literal: true

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

    session[:meme_path] = @meme.meme_path

    redirect '/display_meme', 307
  end

  post '/display_meme' do
    send_file(session[:meme_path])
  end
end
