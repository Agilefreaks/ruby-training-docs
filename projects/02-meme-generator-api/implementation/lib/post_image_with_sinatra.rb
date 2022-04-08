# frozen_string_literal: true

require 'sinatra/base'

class PostImageWithSinatra < Sinatra::Base
  get '/redirect' do
    redirect '/images/image1.jpg', 307
  end

  get '/images/:file' do
    path = "./images/#{params[:file]}"
    send_file(path)
  end
end
