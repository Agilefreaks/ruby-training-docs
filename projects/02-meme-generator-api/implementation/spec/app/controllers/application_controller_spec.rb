# frozen_string_literal: true

require './app/controllers/application_controller'
require 'sinatra'
require 'rack/test'

def app
  ApplicationController
end

describe 'GET /' do
  it 'returns Hello message' do
    get '/'
    expect(last_response.status).to eq(200)
  end
end

describe 'GET /memes' do
  it 'opens a form' do
  end
end

describe 'POST /create_meme' do
  it 'redirects to created image' do
    post '/create_meme', image_url:'https://images.unsplash.com/photo-1647549831144-09d4c521c1f1', text:'Start the way by organising your playground'

    expect(last_response.status).to eq(303)
  end
end

describe 'GET /display_meme' do
  it 'opens the created image' do
  end
end
